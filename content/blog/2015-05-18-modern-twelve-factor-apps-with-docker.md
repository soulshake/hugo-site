---
author: Noah Zoschke
date: 2015-05-18T00:00:00Z
title: Modern Twelve-Factor Apps with Docker
twitter: nzoschke
url: /2015/05/18/modern-twelve-factor-apps-with-docker/
---

Docker is awesome for developing [twelve-factor apps](http://12factor.net/).  

[Dockerfile](https://docs.docker.com/reference/builder/) and [docker-compose.yml](https://docs.docker.com/compose/yml/) are emerging standards for declaring everything about your service in the codebase: dependencies, environment, ports, multiple process types, and backing services.

Docker [images and containers](https://docs.docker.com/engine/getstarted/step_two/) offer a contract with the operating system that can be effectively identical between your development environment and production environment.

This is a brief guide for satisfying key factors of twelve-factor with Docker tools. It explains what techniques you can use to develop a archetypical Rails / Postgres / Redis / web / worker application under Docker.

<!--more-->

A future post will deep dive into a code base that demonstrates everything working together.

### II. Dependencies — Explicitly declare and isolate dependencies

Docker [images](https://docs.docker.com/engine/tutorials/dockerimages/) are built from explicit Dockerfile recipes and Docker containers are run as isolated environments.

Dockerfile offers a way to explicitly declare the base operating system ([FROM](https://docs.docker.com/engine/reference/builder/#/from)), and to run commands to install additional system packages and application dependencies ([RUN](https://docs.docker.com/engine/reference/builder/#/run)).

With these tools you can say that you want a Ubuntu 14.04 OS, Ruby 2.2.2, Node 0.11 system to run `bundle install` against.

### III. Config — Store config in the environment

Docker containers rely heavily on linux environments for configuration.

docker-compose.yml has an [environment hash](https://docs.docker.com/compose/compose-file/#/environment) where you explicitly define what environment variables will be set in a container. These can be default values or undefined values that will be inherited from the host at runtime.

Additionally there is the Dockerfile [ENV](https://docs.docker.com/engine/reference/builder/#/env) instruction and the [docker run --env=[]](https://docs.docker.com/engine/reference/commandline/run/#/set-environment-variables--e---env---env-file) and [docker run — env-file=[]](https://docs.docker.com/engine/reference/commandline/run/#/set-environment-variables--e---env---env-file) runtime options.

With these tools you can say that your application expects a `GITHUB_AUTH_TOKEN`.

### VII. Port binding — Export services via port binding

Docker containers rely heavily on port binding.

docker-compose.yml has a [ports array](https://docs.docker.com/compose/compose-file/#/ports) that explicitly defines a HOST:CONTAINER port mapping. [docker run -p HOST:CONTAINER](https://docs.docker.com/engine/reference/commandline/run/#publish-or-expose-port--p---expose) lets you define this at runtime.

With this tool you can say that your application web server is listening on PORT 5000, and that you can access it from the host on PORT 5000.

### IV. Backing Services — Treat backing services as attached resources

Docker containers share little to nothing with other containers and therefore should communicate with backing services over the network.

docker-compose.yml has a [links hash](https://docs.docker.com/compose/compose-file/#/links) where you specify the other containerized services that your application depends on. `docker-compose up` will start these backing services first and set environment variables in the app container with network connection information.

With these tools you can say that your application depends on a backing Postgres 9.4 and Redis 3.0 service and have your application connect to them via hostname and port information present in their environment.

### VI. Processes — Execute the app as one or more stateless processes

By default, Docker containers are shared nothing processes with ephemeral storage.

docker-compose.yml defines a collection of services, each one with its own image or build recipe and command.

With this tool you can say that your application has a both a web and worker process.

### XII. Admin processes — Run admin/management tasks as one-off processes

Docker images are easily run as one-off processes.

`[docker run myapp CMD](https://docs.docker.com/reference/commandline/cli/#run)` will run an arbitrary command in the same environment as your web process.

With this tool you can run an interactive bash prompt or run one-off `rake db:migrate` process against your development Postgres database.

### Prior art

Without Docker, the OS X development tool chain is [Homebrew](http://homebrew.co/) for system dependency packages and development services like Postgres and Redis, Ruby’s [Bundler](http://bundler.io/) for cross-platform development dependencies, a combination of shell scripts and [foreman](http://ddollar.github.io/foreman/) to coordinate running everything locally at the same time, and an independent Linux-based build service to package everything up for production.

There is nothing wrong with this workflow, however Docker offers a more elegant future.

With the right Dockerfile and docker-compose.yml files, we no longer need any OS X system dependencies, service packages, or cross-platform language dependencies. A simple `docker-compose up` can provide a complete Linux development environment that will easily port onto a production machine for any twelve-factor app.
