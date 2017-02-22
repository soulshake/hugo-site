---
title: "Preparing an Application"
order: 100
---

Most production servers run Linux, but a large majority of professional developers prefer to work on a Mac or on Windows. While it is possible to work on most modern programming languages in any operating system, this discrepancy can lead to subtle bugs that are not noticed until an application reaches production.

Linux containers solve many of these issues, allowing you to fully specify a working artifact and then run it easily on both your local development machine and production. Convox uses containers under the hood to ensure that your development environment is identical to production.

We believe a development environment should have these properties:

#### Declarative

Your application's structure and environment should be fully enumerated in a manifest of some kind.

#### Exhaustive

Any changes from the default environment should be fully specified. Anything not specified should not be available to the running system.

#### Reproducible

Deterministic builds, common runtimes, and explicit environments ensure that code running successfully in development will also run successfully and predictably in production.

## Manifests

Convox infers information about your application from the following files:

#### Dockerfile

This file documents the steps necessary to build your application into an executable artifact.

#### docker-compose.yml

This file describes the structure of your application and how the pieces connect to each other.

## Intialization

If you don't yet have these manifest files in your application, Convox can build them for you.

    $ convox init
    
Running this command will create a default `Dockerfile` and `docker-compose.yml` that you can use to get started.

## Defining your Application

Let's take a look at how to use these files to define your application in the context of an [example application](https://github.com/convox-examples/sinatra).

#### docker-compose.yml

The `docker-compose.yml` for this application looks like this:

    web:
      build: .
      command: bin/web
      environment:
        - MYSERVICE_API_KEY
        - RACK_ENV=development
      labels:
        - convox.port.443.protocol=tls
      ports:
        - 80:3000
        - 443:3000
      links:
        - postgres
        - redis
    worker:
      build: .
      command: bin/worker
      environment:
        - RACK_ENV=development
      links:
        - postgres
        - redis
    redis:
      image: convox/redis
      ports:
        - 6379
    postgres:
      image: convox/postgres
      ports:
        - 5432


Each top level key defines the processes necessary to run your application. This particular manifest describes four processes: `web`, `worker`, `postgres`, and `redis`.

* The `postgres` and `redis` processes are defined as images. These will be pulled from [Docker Hub](https://hub.docker.com/) as necessary.

* The `web` and `worker` processes have a `build` key which instructs `convox start` to build an image using the `Dockerfile` in the specified directory.

* The `environment` key declares environment variables for this process. Defaults can be specified. Any variable with no value (such as `MYSERVICE_API_KEY`) must be declared in your local environment to start the application successfully (see the section on `.env` below for more details)

* The `ports` key declares the ports on which a process will listen. Listing `- 6379` instructs the process to listen on port 6379 for traffic from other processes in the application. Including an optional prefix exposes an internet-facing port, e.g. `- 80:3000` sends port 80 internet traffic to the process listening on port 3000 inside the container.

* The `links` key defines dependencies on other processes named in this file. `convox start` sets environment variables so that a process can find its links. See [Linking](/docs/linking) for more details.

* The `labels` key is used by Convox to offer configuration settings that are not part of the official Docker Compose spec. In this example we use the `convox.port.443.protocol` label to configure a TLS listener on the load balancer. For a full list of supported labels, see the [Docker Compose Labels](/docs/docker-compose-labels) reference.

#### Dockerfile

    FROM gliderlabs/alpine:3.2

    RUN apk-install ruby ruby-bundler ruby-io-console ruby-kgio ruby-pg ruby-raindrops ruby-unicorn

    WORKDIR /app

    # cache bundler
    COPY Gemfile /app/Gemfile
    COPY Gemfile.lock /app/Gemfile.lock
    RUN bundle install

    # copy the rest of the app
    COPY . /app

    ENTRYPOINT ["bundle", "exec"]
    CMD ["bin", "web"]

The `Dockerfile` describes the steps you need to build and run your application.

* `FROM` defines the base image for your application.

* `COPY` moves files from the local directory into the image.

* `RUN` executes a command.

* `ENTRYPOINT` defines a command prefix that should be prepended to any command run on this image.

* `CMD` defines the default command to start application.

For more information on how to write Dockerfiles, see the [Docker user guide](https://docs.docker.com/engine/tutorials/dockerimages/#/building-an-image-from-a-dockerfile) and the [Dockerfile reference](http://docs.docker.com/reference/builder/).

Convox also offers custom Docker configuration as a paid service. To find out more about scheduling and pricing, contact us via the chat icon on the bottom right of your screen.
