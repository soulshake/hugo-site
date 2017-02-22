---
author: Noah Zoschke
date: 2016-06-30T00:00:00Z
title: Why Docker? The Image API is Everywhere
twitter: nzoschke
url: /2016/06/30/why-docker/
---

The most common question to my [Docker For Mac Beta Review](https://medium.com/@nzoschke/docker-for-mac-beta-review-b91692289eb5) is: Why use Docker at all?

The reason to use Docker is for its modern packaging and runtime APIs. The Docker [Image](https://docs.docker.com/engine/reference/api/docker_remote_api_v1.23/#2-2-images) and [Container](https://docs.docker.com/engine/reference/api/docker_remote_api_v1.23/#2-1-containers) APIs have become a [de facto standard](https://en.wikipedia.org/wiki/De_facto_standard). Every major computing platform — from OS X to AWS — now has native support for working with Docker Images and Containers.

This happened because Docker presented a modern, API-first approach to distributing and running software at the exact time when we all want cloud providers interoperate better.

This is an unprecedented feat of cooperation across the industry and makes these Docker APIs the obvious best system to target.

<!--more-->

![Docker, Docker, Docker](/assets/img/why-docker-providers.png)*Docker, Docker, Docker*

## Packaging Before and After Docker

Packaging is nothing new. For decades we have been packaging Operating Systems as images to run with Virtual Machine software:

* .iso — Raw disk images

* .vdmk — VMWare Disk Images

* .box — Vagrant Boxes

* .ovf — Open Virtualization Format

* AMI — Amazon Machine Images

We have been building application package archives to run on another computer:

* .zip and .tgz — Who knows? Source distribution or platform specific binary distribution

* .deb — Debian packages

* .rpm — Redhat Packages

* Shell/Perl/Ruby scripts — Homebrew, Makefile and bespoke distribution

There has been plenty of work and tooling for systems to interoperate with the different archive formats, but we can’t deny that virtual machine images are proprietary and clunky, and application packages have been hard to build, maintain and distribute.

Docker changed all this with Images and the [Image API](https://docs.docker.com/engine/reference/api/docker_remote_api_v1.23/#2-2-images).

With Docker, an entire operating system and application is:

* Programmatically defined by a simple Dockerfile

* Built on any platform —  from a laptop to Jenkins — with a simple `docker build` command

* Pushed to any service that implements [Image Registry APIs](https://github.com/docker/distribution)

* Pulled on any platform — from a laptop to AWS — with a simple `docker pull` command

```
FROM ubuntu:16.04

RUN apt-get update
RUN apt-get -yy install build-essential ruby-dev
RUN apt-get -yy install libmysqld-dev libpq-dev libsqlite3-dev
RUN apt-get -yy install nginx nodejs

WORKDIR /app

ENV PORT 5000

RUN gem install bundler

COPY bin/web /app/bin/web
COPY conf/convox.rb /app/config/initializers/convox.rb
COPY conf/nginx.conf /etc/nginx/nginx.conf

CMD ["bin/web"]
```

Compared to building vendor specific VM images and OS specific application package archives, Docker Images are clearly a better format to target:

* Build on a laptop, Travis CI, CircleCI, CloudBees, etc.

* Push to Docker Hub, Quay, GitLab, AWS ECR, Google Container Registry, etc.

* Run on a laptop, AWS, Joyent, Google, Heroku, Digital Ocean, etc.

## Process Management Before and After Docker

Process management is also nothing new. We are all intimately familiar with various operating system calls and interactive shells to run, introspect and stop processes.

* Shells like bash, sh, zsh, and cygwin

* Utilities like `ps`, `top`, and `tail`

* Task management systems like init, upstart and systemd

* Virtualization tools like kvm, qemu and zen

* Security and Containerization tools like chroot, jails and lxc

Docker improved on all this with Containers and the [Container API](https://docs.docker.com/engine/reference/api/docker_remote_api_v1.23/#2-1-containers).

With Docker, every process is:

* Distributed with an entire OS filesystem

* Started, interacted with, and stopped via a Docker daemon by any tools that know the [Container APIs](https://docs.docker.com/engine/reference/api/docker_remote_api_v1.23/#2-1-containers)

We are familiar with tools like `docker run`, `docker ps`, `docker stats`, `docker logs`, and `docker kill`. These are utilities that come out of the box with Docker that wrap the APIs. 

![Docker Tools in Production. No custom AMI required.](https://medium2.global.ssl.fastly.net/max/7860/1*Dx070Ud3KNx7l1F9XcVJKg.png)*Docker Tools in Production. No custom AMI required.*

But now that everything on a system can be accomplished via well-documented APIs and language client libraries like the [go-dockerclient](https://github.com/fsouza/go-dockerclient), extremely sophisticated process management systems have emerged.

A simple example is that `docker ps` works exactly the same on my OS X computer and on AWS, where `ps` doesn’t due to differences between the BSD and GNU implementations.

An extreme example is that AWS ECS turns one or more instances running `dockerd` into a compute cluster. You can ask this cluster to run 5 web processes, and an agent will tell the Docker daemons to start the 5 web processes on different hosts. It will then constantly introspect the Docker daemons and will start a new container if it observes that a container failed.

Before Docker, cluster computing had been tied very closely to specific operating systems like [RedHat Cluster Suite](https://en.wikipedia.org/wiki/Red_Hat_cluster_suite) or [Solaris Cluster](https://en.wikipedia.org/wiki/Solaris_Cluster) and lots of platform specific glue. The Docker Remote APIs make cluster computing approachable for far more users.

Compared to previous process management techniques Docker Containers are clearly a better format to target. The engine runs everywhere, and the API-first design makes it easier to program around than any other systems programming techniques before it.

## De Facto Standard

Docker’s initial hype was because the new Image and Container concepts and APIs are modern, powerful and actually fun ways to interact with a computer. Demos where `docker-compose up` brings up an entire application — including microservices and databases — proved that there is something new and exciting to the Docker tools.

Providers saw the trend and listened, making it possible to push Docker Images into systems in addition to their old, proprietary formats.

The next iteration of this concept will come from the [Open Container Initiative](https://www.opencontainers.org/), but we can all be certain that any other standards in this space will be heavily influenced and very compatible with the existing Docker APIs.

![Industry Cooperation](https://medium2.global.ssl.fastly.net/max/2328/1*UWOC6AEQXQUaLYMgSCheLg.png)*Industry Cooperation*

## Why Not Docker?

When talking about just the Image APIs I don’t see any reason why you wouldn’t target Docker Images when building something new.

I ask this question to you… Is there a distribution format that’s simpler, easier or more supported than Docker Images now?

That said, I do understand and share concerns about other parts Docker. 

For starters, if you’re happy with your current packaging and runtime solutions, don’t throw them away. Conservatism will pay off as the container space rapidly evolves. The hype cycle is definitely in effect.

Next, I recommend caution in going deeper into the Docker universe than Images and Container APIs right now.

There is interesting work in the Docker container scheduling space (Swarm, Mesos, Kuberenetes, Nomad), but these are extremely complex systems that can bring in massive headaches for you and your team. These dynamic systems make networking, load balancing, logging and debugging **harder than ever before**.

I recently wrote up a bunch of the [biggest challenges I have building systems on top of AWS ECS](https://medium.com/@nzoschke/the-seven-biggest-challenges-of-deployment-to-ecs-414ebcd6d9ec#.n1etvfynm), and that’s with letting Amazon operate most of the system.

If you don’t know what you are doing, you can end up with a Docker system that is overly complex on the container, network, persistence and scheduling fronts.

## Conclusion

Why Docker? We have always needed tools to package, distribute and run software. Docker took a fresh approach to all this and is now widely supported across the entire industry.

Building Docker Images and running software with the Docker Container APIs guarantees operability between every personal computer and CI and Cloud providers.

Building AMIs, making Homebrew scripts, managing an APT repositories and and writing custom shell scripts and Makefiles didn’t come anywhere close.
