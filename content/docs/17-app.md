---
title: Apps
permalink: /guide/app/
phase: deploy
---

An _app_ is a collection of one or more services that share a common code base, environment configuration, and manifest (like `docker-compose.yml`).

# Creating our app

Since we haven't created any apps yet, running `convox apps` should show an empty list:

```
$ convox apps
APP  STATUS
```

Let's create our first app:

```
$ convox apps create
Creating app convox-guide... CREATING
```

Running `convox apps create` without any arguments will cause `convox` to name the app after the name of the current working directory (in our case, `convox-guide`).

This will take a few minutes. We can view its progress by running `convox apps` again:

```
$ convox apps
APP           STATUS
convox-guide  creating
```

Once it's complete, `convox apps` should show our new application is `running`:

```
$ convox apps
APP           STATUS
convox-guide  running
```

You can get more detailed information about the app by running `convox apps info <appname>`. At this point, it will look pretty empty:

```
$ convox apps info
Name       convox-guide
Status     running
Release    (none)
Processes  (none)
Endpoints  
```


# Deploying our app

At the moment, our list of releases is still empty:

```
$ convox releases
ID  CREATED  BUILD  STATUS
```

Let's deploy our app!

```
$ convox deploy
Deploying convox-guide
Creating tarball... OK
Uploading: 1.67 KB / 1.50 KB [===========================] 111.55 % 0s
Starting build... OK
Authenticating 922560784203.dkr.ecr.us-east-1.amazonaws.com: Login Succeeded

running: docker build -f /tmp/323391563/Dockerfile -t convox-guide/web /tmp/323391563
Sending build context to Docker daemon 12.29 kB
Step 1 : FROM ubuntu:16.04
16.04: Pulling from library/ubuntu
668604fde02e: Pulling fs layer
2879a7ad3144: Waiting
668604fde02e: Waiting
fc19d60a83f1: Verifying Checksum
[snip]
8ba4b4ea187c: Layer already exists
c854e44a1a5a: Layer already exists
worker.BXFGHCQLZGQ: digest: sha256:bbc8105072a4401cd8d3a589ce2eaa42e876f9d33b04b02b0518a6f8d6fd5974 size: 7865
Promoting RZYWJKKRDLI... UPDATING
```

If we run `convox apps info` immediately, we can see our app doesn't have any endpoints yet:

```
$ convox apps info
Name       convox-guide
Status     updating
Release    RZYWJKKRDLI
Processes  redis web worker
Endpoints  :80 (web)
           :443 (web)
           :6379 (redis)
```

At first, while `Status` is `updating`, we won't see the full endpoints. Wait a few minutes and run `convox apps info` again:

```
$ convox apps info convox-guide
Name       convox-guide
Status     running
Release    RZYWJKKRDLI
Processes  redis web worker
Endpoints  convox-guide-web-Z5YQ7FA-1775143282.us-east-1.elb.amazonaws.com:80 (web)
           convox-guide-web-Z5YQ7FA-1775143282.us-east-1.elb.amazonaws.com:443 (web)
           internal-convox-guide-redis-AMC3S3W-i-984626821.us-east-1.elb.amazonaws.com:6379 (redis)
```

Now the `Endpoints` are visible! Note that after deploying for the first time, it will take a few minutes for these domains to resolve due to DNS propagation. (To minimize propagation time, wait a few minutes before trying them.)

Once the endpoints have propagated, you should be able to view your app online:

```
$ curl convox-guide-web-Z5YQ7FA-1775143282.us-east-1.elb.amazonaws.com
Hello World!
```


Next, let's look at how Convox helps you manage [releases](/guide/releases).

{% include_relative _includes/next.html
  next="Manage releases"
  next_url="/guide/releases/"
%}
