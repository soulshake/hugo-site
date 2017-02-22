---
author: Noah Zoschke
date: 2016-12-16T00:00:00Z
title: The Challenges of EFS
twitter: nzoschke
url: /2016/12/16/challenges-of-efs/
---

I have been experimenting with Amazon’s Elastic File System (EFS) service on a real web app running across multiple instances. 

With some effort, I have a file upload and sharing app serving from three web servers sharing a single EFS volume. But due to the performance characteristics of EFS, it wasn’t easy to get going.

The good:

* EFS does offer shared persistence across many EC2 instances and/or ECS containers

* EFS has [rigorously documented performance rates](http://docs.aws.amazon.com/efs/latest/ug/performance.html) and recommended settings for web apps

* [EFS CloudWatch metrics](http://docs.aws.amazon.com/efs/latest/ug/monitoring-cloudwatch.html) are very good

The bad:

* SQLite on EFS doesn’t work

* Web servers can show high response time and variance due to cold EFS access

The ugly:

* Individual file writes have noticable latency

* A standard untar operation to EFS is going at a mere **204 kBps**

![EFS Performance Characteristics](https://medium2.global.ssl.fastly.net/max/2000/1*-4E7rbrcmg013Q3jqZu9ng.png){: .center }*EFS Performance Characteristics*

All this leads me to conclude that **EFS works ok.** I am actually happy with the app deployment after getting it all set up. 

However the **relatively slow performance** could require **code changes** and an **putting a CDN in front** of many types of web apps.

Let’s dig into running a horizontally scaled web app on EFS.

<!--more-->

## EFS Primer

EFS is an implementation of the Network File System (NFS) protocol. 

On AWS, every instance uses an NFS client to connect to the EFS endpoint, and synchronizes file metadata and data over the network. 

Because NFS looks like a standard filesystem, it integrates with virtually any system. For example, it is trivial to use an EFS volume with ECS and Docker containers.

Amazon offers a lengthy doc about [EFS performance](http://docs.aws.amazon.com/efs/latest/ug/performance.html) and NFS filesystem tuning. Baseline throughput, burst throughput and credits are complicated but well documented.

## Test Harness

I have been doing my AWS testing with [Convox](https://convox.com/), an [open-source](https://github.com/convox/rack) PaaS built on top of AWS services. Following a "use services, not software" philosophy, Convox uses EFS for [persistent container volumes](https://convox.com/docs/volumes/).

With the Convox tools it only takes a few minutes to set up a production-ready three node ECS cluster with EFS and deploy an app to it.

The app I am testing is ownCloud. This is an open-source PHP program that’s primary purpose is to store and serve lots of file uploads. 

It is distributed as a Docker image that uses Docker volumes serve the app and save and retrieve file uploads.

I am using EFS in “General Purpose Performance Mode”, the recommended setting for web server environments. I am also using the [recommended Linux mount options](http://docs.aws.amazon.com/efs/latest/ug/mounting-fs-mount-cmd-general.html).

![EFS Management Console](https://medium2.global.ssl.fastly.net/max/6032/1*H-MoTFwXult9oZeHld9KMw.png){: .center }*EFS Management Console*

    $ mount

    us-east-1e.fs-d.efs.us-east-1.amazonaws.com://dev-east-owncloud/main/var/www/html on /var/www/html type nfs4
    (rw,relatime,vers=4.1,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=10.0.2.19,local_lock=none,addr=10.0.2.33)

## ownCloud App

Since ownCloud has [official Docker images](https://hub.docker.com/_/owncloud/) that use Docker volumes for data, we can write a simple manifest and deploy it:

    $ cat docker-compose.yml

    version: "2"
    services:
    main:
      image: owncloud
      volumes:
        - /var/www/html
      ports:
        - 80:80
        - 443:80

    $ convox apps create

    Creating app owncloud... CREATING

    $ convox deploy

    Deploying owncloud
    Creating tarball... OK
    Uploading: 421 B / 244 B [=============================] 172.54 % 0s
    Starting build... OK
    running: docker tag owncloud/main dev-east-owncloud-gjrkneuuoz:main.BCHEGGUMFXF
    running: docker push main.BCHEGGUMFXF: digest: sha256:4160dd48 size: 27574
    Promoting RWXASFZWUWA... UPDATING

    $ convox logs

    2016-12-14T23:08:42Z agent:0.70/i-06c8c168fabe019d1 Starting main process 53ceb9da4062
    2016-12-14T23:13:06Z agent:0.70/i-06c8c168fabe019d1 Stopped main process 53ceb9da4062 via SIGKILL
    2016-12-14T23:09:23Z agent:0.70/i-0bd90534214c0218f Starting main process b650d1f51dc0
    2016-12-14T23:13:09Z agent:0.70/i-0bd90534214c0218f Stopped main process b650d1f51dc0 via SIGKILL
    ...

The logs indicate the main container is not passing a health check in 30 seconds so it is constantly terminated and restarted. What gives?

## First Boot Times Out

If we dig into the [ownCloud Dockerfile](https://github.com/docker-library/owncloud/blob/373a10dfe09623b32510f64912d2188c6395f64e/9.1/apache/Dockerfile) we see that it’s [entrypoint script](https://github.com/docker-library/owncloud/blob/373a10dfe09623b32510f64912d2188c6395f64e/9.1/apache/docker-entrypoint.sh) is copying lots of data from the Docker image to the persistent /var/www/html volume:

    #!/bin/bash
    set -e
    if [ ! -e '/var/www/html/version.php' ]; then
      tar cf - --one-file-system -C /usr/src/owncloud . | tar xf -
      chown -R www-data /var/www/html
    fi

    exec "$@"

This volume is backed by EFS. Could this be the reason it’s taking more than 30 seconds to boot? Let’s try the command interactively:

    $ convox run main bash

    root@b650d1f51dc0:/var/www/html# time tar cfv - --one-file-system -C /usr/src/owncloud . | tar xf -

    real 8m48.509s
    user 0m0.532s
    sys 0m3.744s

8 minutes to untar onto the EFS volume?! Yikes.

## Copy I/O Baselines

The ownCloud image is trying to copy **11,000 files** that take up **98 MB** to the EFS volume.

I saw between **204 kBps** for the sequential untar and **1.63 MBbs** for a parallel rsync.

Some baselines of various tar commands 

* **1 second** to untar all the **files to /dev/null**

* **8 minutes** to untar all the **files to EFS**

* **36 seconds** for untar to **check existing files on EFS** and skip data

* **10 seconds** to tar all the **files from EFS**

Then I took some rsync baselines, since it’s more hackable than tar:

* **10 minutes** to rsync all the **files to EFS**

* **30 seconds** for rsync **to check existing files on EFS** and skip data

* **1 minute** to rsync **the files to EFS in parallel** (1000 concurrent workers)

## EFS Metrics

The CloudWatch metrics for EFS are very good. 

I can see over the course of the experiment that initial I/O percentage (red line) wasn’t coming anywhere near 100%. With lots of parallelism I could eventually max out IO which brought copy time down significantly.

![](https://medium2.global.ssl.fastly.net/max/4204/1*jFjbyYQHwbsviDuq1eOoqA.png){: .center }*Visibility*

## Now The App Boots!

The manual tests had a big positive side-effect. Since EFS is persistent, the ownCloud `version.php` file now exists on the volume, so the entrypoint no longer needs to do the untar. The app boots!

    $ convox logs

    agent:0.70/i-06c8c168fabe019d1 Starting main process 1457c7a3ac38
    main:RWXASFZWUWA/1457c7a3ac38 [Wed Dec 14 23:26:48.412478 2016] [core:notice] [pid 1] AH00094: Command line: 'apache2 -D FOREGROUND'

    $ convox apps info

    Name       owncloud
    Status     running
    Release    RWXASFZWUWA
    Processes  main

    Endpoints  owncloud-main-1899916604.us-east-1.elb.amazonaws.com:443
               owncloud-main-1899916604.us-east-1.elb.amazonaws.com:80

    $ curl owncloud-main-1899916604.us-east-1.elb.amazonaws.com

    <!DOCTYPE html>
    <html class="ng-csp" data-placeholder-focus="false" lang="en" >
    <head>
    <title>ownCloud</title>
    ...

## Database on EFS?

ownCloud defaults to SQLite. It shows a big performance warning around SQLite on any filesystem. But does it work on EFS? 

No.

I get an I/O error creating the database. Looking at the volume the database file is 0 bytes.

It seems like the write latency is a challenge for the PHP code and SQLite database driver.

Of course I would heed the SQLite warning in all cases and use RDS. [Configuring that](https://convox.com/docs/postgresql/) and I finally have ownCloud running!

![](https://medium2.global.ssl.fastly.net/max/2000/1*oD0Hgni5Ka_DVLfamgPXpg.png){: .center }*SQLite Errors*

## Traffic Benchmarks

Finally I wanted to look at how the application performs.

First I uploaded 20 photos knowing these will be saved to EFS. I didn’t perceive any slowness outside of normal file upload time.

Then I shared this folder publicly, which gave me a URL to a page with the 20 photos, thumbnails and metadata.

I benchmarked this page with Apache Bench:

    $ ab -n 100 -c 10 http://owncloud-main-1899916604.us-east-1.elb.amazonaws.com/index.php/s/H420DZJgYN9GUVH

    Document Length:        15703 bytes
    Concurrency Level:      10
    Time taken for tests:   10.134 seconds
    Complete requests:      100
    Failed requests:        0
    Total transferred:      1667818 bytes
    HTML transferred:       1570300 bytes
    Requests per second:    9.87 [#/sec] (mean)
    Time per request:       1013.363 [ms] (mean)
    Time per request:       101.336 [ms] (mean, across all concurrent requests)
    Transfer rate:          160.73 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:       82   89   3.7     88     100
    Processing:   845  922  40.1    918    1011
    Waiting:      758  832  38.4    829     920
    Total:        929 1011  40.0   1005    1098

    Percentage of the requests served within a certain time (ms)
     50%   1005
     66%   1026
     75%   1034
     80%   1038
     90%   1086
     95%   1087
     98%   1094
     99%   1098
    100%   1098 (longest request)

**One second for every response** isn’t great but isn’t horrible either. And the response times are very consistent.

## Scaling Out The Web App

Finally, I’m ready to test the true promise of EFS. I can scale out my web containers since they all share the same EFS volume. Every container is running on its own instance.

How does this affect performance?

    $ convox scale main --count=3

    $ ab -n 100 -c 10

    Complete requests:      100
    Failed requests:        0

    Percentage of the requests served within a certain time (ms)
     50%    695
     66%    743
     75%    765
     80%    805
     90%   1665
     95%  12044
     98%  12694
     99%  12864
    100%  12864 (longest request)

All the requests returned, but **performance decreased**. Some requests took **12 seconds** to return. 

The variance must be due to the containers coming up on instances that are “cold” and accessing the data the first time.

After a few more runs of Apache Bench over the next minutes the performance evened out.

    Percentage of the requests served within a certain time (ms)
     50%    694
     66%    705
     75%    718
     80%    725
     90%    771
     95%    875
     98%    906
     99%    910
    100%    910 (longest request)

## Conclusions

Even after all this, I feel pretty good about running a web app off EFS. 

I now have **web app served from a shared EFS data volume**. The app feels fine for normal file uploads and downloads. Response times can be slower and more variable that I’d like, but once the app is “warmed up” it benchmarks well.

This web is **highly available**, **horizontally scalable** and required **no code changes**. The data is also **highly available** with **no operational work**.

The **visibility through CloudWatch is very good** showing I’m not anywhere close to maxing out EFS I/O.

For this particular type of app, the final step would be to **add a CDN to improve performance** and have the best of all worlds.

That said, the performance characteristics of EFS are concerning. Just like SQLite not working and tar going slow, I can see many standard apps having trouble with the latency or throughput. This could be a deal breaker for many apps.

## Questions…

When EFS was announced, many people immediately dismissed it saying that NFS has no place near production. Is this still the case?

How do we do better for sharing data across instances and containers? Do we need to operate our own NFS server or distributed file system to take control over performance?

Maybe the lack of raw performance is acceptable for the consistency and reliability of the EFS service?

Or do we stick to stateless apps at the [Twelve Factor App](https://12factor.net/) wisely suggests?

Tweet at [@goconvox](https://twitter.com/goconvox) or [chat with us in Slack](http://invite.convox.com/) to discuss.
