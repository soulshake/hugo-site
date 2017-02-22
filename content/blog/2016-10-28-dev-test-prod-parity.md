---
author: Noah Zoschke
date: 2016-10-28T00:00:00Z
title: Dev → Test → Prod Parity with Docker
twitter: nzoschke
url: /2016/10/28/dev-test-prod-parity/
---

The [Twelve Factor App](https://12factor.net/) methodology is a series of best practices to follow when building your app to make it easy to deploy to the cloud.

One of the factors is [Dev/Prod Parity](https://12factor.net/dev-prod-parity):

> Keep development, staging, and production as similar as possible

It argues that we should aim to reduce gaps between development and production to increase software quality and velocity. Every gap, be it between people, time or computing environments, adds friction.

One way this commonly manifests is that code "works for me!" on your laptop, but doesn’t start on your team mate's without extra work. The worst case scenario is that this code is deployed and doesn't work in production, taking the service down.

This friction can add up to significant time over the lifecycle of software. In the above scenario you and your fellow Developers are spending precious time futzing with your laptop environment, and your fellow DevOps engineers are getting paged because the service is down.

Dev/Prod Parity is an aspiration goal in Twelve Factor, but it’s actually possible to achieve with Docker Images and Containers.

<!--more-->

# What Parity?

A very common setup is [Homebrew](http://brew.sh/) for development on a Mac laptop, [CircleCI](https://circleci.com/) for testing and [Heroku](https://www.heroku.com/) for production. With these systems, it’s hard to know, let alone guarantee, what version of Node.js, ImageMagick and Postgres are used in each environment.

![Laptop, CI Service, and Production Service Incompatibility Matrix](/assets/img/dev-test-prod-matrix.png){: .center } *Laptop, CI Service, and Production Service Incompatibility Matrix*

It’s not impossible to set it all up, but there are pitfalls.

You need to:

- Maintain good documentation and scripts in the app codebase to help maintain a Homebrew environment
- Wrangle a [circle.yml](https://circleci.com/docs/configuration/) file, and SSH in to failed test runners to figure out what packages to install to get the test environment running
- Understand what the Heroku [Buildpacks](https://devcenter.heroku.com/articles/buildpacks) and Runtime add to build and run your app in production
- Add hooks to your code base to turn functions off or on in development, testing and production

Once it works, it’s smooth sailing. Until you want to upgrade Ruby, or add PhantomJS for web acceptance testing, or Homebrew packages change, or...

# Parity Begins in Development With Containers

Containerization technology, made accessible by Docker, offers a better way.

First, install the fantastic [Docker for Mac](https://docs.docker.com/engine/installation/mac/) to get a Docker environment running on your laptop. This app is practically magic, and offers a fast Linux environment on your Mac laptop.

Next, put in some effort to "Dockerize" your app. The goal is to boot your app with a single command: `docker-compose up` or `convox start`. This involves writing a `Dockerfile` and a `docker-compose.yml` file.

Apps that already follow the Twelve Factor Methodology aren’t too hard to get into shape.

First, you need to describe each process in your Procfile as a "Service" in `docker-compose.yml`. You also need to add a Service for any database your app uses like Postgres or Redis. This frees you from needing to use anything in Homebrew for development.

    version: '2'
    services:
      web:
        build: .
        command: ["node", "web.js"]
        links:
         - redis
      worker:
        build: .
        command: ["node", "worker.js"]
        links:
         - redis
      redis:
        image: redis

Next, you need write a `Dockerfile` that can build and run your app. You need to pick a base operating system, add system dependencies, then add a few more commands to install the language packages your app uses.

I recommend using Ubuntu 16.04. Ubuntu 16.04 makes it easy to get the latest Node.JS, Ruby, Python, and PHP system packages. It is a "Long Term Support" distribution that will receive security updates through 2021. This is another huge advantage of Docker: we are no longer constrained by the limited CircleCI and Heroku operating system choices.

    # start from a base Image
    FROM ubuntu:16.04
    
    # install system dependencies
    RUN apt-get update && \
      apt-get install -y nodejs npm && \
      update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
    
    # specify the app location
    WORKDIR /app
    
    # install app dependencies
    COPY package.json /app/package.json
    RUN npm install
    
    # add app source code
    COPY . /app

Getting it all working might take some effort, but it’s so satisfying when `docker-compose up` works:

    $ docker-compose up

    Creating network "myapp_default" with the default driver
    Pulling redis (redis:latest)...
    Building web
    Step 1 : FROM ubuntu:16.04
    Step 2 : RUN apt-get update &&   apt-get install -y nodejs npm &&   update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
    Step 3 : WORKDIR /app
    Step 4 : COPY package.json /app/package.json
    Step 5 : RUN npm install
    Step 6 : COPY . /app
    Building worker
    Creating myapp_redis_1
    Creating myapp_web_1
    Creating myapp_worker_1
    redis_1   | 1:M 27 Oct 14:17:16.329 # Server started, Redis version 3.2.0
    worker_1  | [nodemon] 1.11.0
    worker_1  | [nodemon] to restart at any time, enter `rs`
    worker_1  | [nodemon] watching: *.*
    worker_1  | [nodemon] starting `node worker.js`
    worker_1  | worker running
    web_1     | [nodemon] 1.11.0
    web_1     | [nodemon] to restart at any time, enter `rs`
    web_1     | [nodemon] watching: *.*
    web_1     | [nodemon] starting `node web.js`
    web_1     | web running at [http://127.0.0.1:8000/](http://127.0.0.1:8000/)

# Test Parity Follows

Now that `docker-compose up` boots your app, try `docker-compose run web npm test` or the equvalent. It might just work!

    $ docker-compose run web npm test

    > myapp@1.0.0 test myapp
    >  User
        #create()
          ✓ should create a new user
      ...
      45 passing (1800ms)

If it doesn't, you'll need a bit more tweaks to your `Dockerfile` and `docker-compose.yml`. You might be missing a few system dependences or environment your tests need.

That effort we put in before is paying off big time. There is **little to no configuration needed to run tests**. And now every team member can run tests on their laptop with a single command. No Homebrew required!

# Test Strategies

If the "Dockerized" app runs on a Docker for Mac environment with a single command, it will certainly run on any test service that supports Docker. There are many:

* CircleCI — [Continuous Integration w/ Docker](https://circleci.com/docs/docker/)

* TravisCI — [Using Docker-Compose in Builds](https://docs.travis-ci.com/user/docker/#Using-Docker-Compose)

* GitLab CI — [Using Docker Build](https://docs.gitlab.com/ce/ci/docker/using_docker_build.html)

* Jenkins — [Docker Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Docker+Plugin)

Before, we needed to write complex configuration for these platforms. Now we need to follow the simple steps to enable Docker and run a single command.

# Prod Strategies

If our app is so well behaved that it runs on a laptop and a test environment with a single command, we can confidently deploy it to the cloud.

AWS has a number of Docker strategies:

* Elastic Beanstalk — [Multicontainer Docker Environments](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker_ecs.html)

* EC2 Container Service — [ecs-cli compose](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/cmd-ecs-cli-compose.html)

* [Convox](https://convox.com/) and [Empire](https://github.com/remind101/empire) open-source platforms

* [Docker for AWS](https://beta.docker.com/docs/aws/)

Not to mention [Heroku Container Runtime](https://devcenter.heroku.com/articles/container-registry-and-runtime), [Google Container Engine](https://cloud.google.com/container-engine/), [Azure Container Service](https://azure.microsoft.com/en-us/services/container-service/), [Docker Cloud](https://cloud.docker.com/), [Joyent Triton](https://www.joyent.com/triton).

There are almost too many strategies here! We will have to explore the pros and cons of these approaches in future post.

But you can be confident that you’ll be able to run your app in the cloud, again with little to no extra configuration.

# Conclusion

Dev/Prod parity is a desirable goal and is possible with Docker Images and Containers.

Put in the work to write a Dockerfile and docker-compose.yml file that works on Docker for Mac, and you have unlocked many paths to test your app and run it in production with little to no additional configuration.

This will increase software quality and velocity, and pay big dividends over the lifetime of the software.

What do you think? Are you already enjoying dev/test/prod parity? Is Docker part of your success? If not, how do you plan to get there?
