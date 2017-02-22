---
author: Matt Manning
date: 2016-06-16T00:00:00Z
title: True Containerized Development with Convox Code Sync
twitter: mattmanning
url: /2016/06/16/bidirectional-sync/
---

About a year ago I published a blog post called "[A Tale of Two Onboardings](https://convox.com/blog/a-tale-of-two-onboardings/)" that was widely shared. I think people responded to it, because it painted a picture of an easier world where a development machine with Docker installed can boot anything you need for your development workflow with a single command.

This kind of workflow — where you develop inside a running container — has been a promise of Docker for as long as I’ve known about it, but a great developer experience has never been fully realized, until now.

The Convox CLI now has the ability to enhance Docker usage with 2-way code sync. In the latest release, `convox start` will instantly sync file changes from your Docker host to your container and from your container to your host. This enables you to:

- Edit files on your host using your favorite text editor and see file changes reflected in the container immediately.
- Run commands that generate code changes on the container and have that code appear on your host where you can commit it to version control.

<!--more-->

## How does it work?

When you run `convox start`, the CLI watches the files on your host and copies any changes to your built container(s).

It also copies a small Linux binary onto your built containers to watch for changes there. This binary logs changes to STDOUT where the CLI is listening, and the CLI copies changed files back to the host.

Files are only synced with containers that are built from a Dockerfile in your project, and only files and directories that appear in COPY or ADD statements in the Dockerfile are synced.

## Why not Docker volumes?

But wait a minute. Isn’t this what Docker volume mounts are for? Well, yes and no. Docker volumes are a good way to share files between the host and container in some cases, but sharing your whole code directory comes with a couple of known, gnarly problems.

1. **Performance.** When running apps written for high-level scripting languages, it’s common for a large number of files to be touched on each request. Volume performance isn’t an issue on Linux, but it’s unusably slow on OS X with Docker Machine or Docker for Mac. For example, we’ve regularly seen single Rails requests in excess of 60 seconds using Docker volumes.
2. **File masking.** Docker volumes use overlay mounts. That means the host directory is mounted over the corresponding container directory, making any files that previously existed exclusively on the container unavailable. This is problematic if you want to build [useful files](https://github.com/convox/rails/blob/80343c751c87be20b1f15c7293d386ceb6824e40/Dockerfile#L8-L9) into a base Docker image that your app’s Dockerfile inherits from.

## Why is this cool?

With this feature you can finally realize true container-based development with Docker! This has many powerful implications:

- You no longer have to depend on verbose documentation or easily lost tribal knowledge to know how to set up development environments. The code is the configuration.
- A true one-command boot means you can rapidly onboard new developers. They can start with a known good working system instead of having to slog through a potentially complicated setup process.
- Your production, staging, test and development environments can run the exact same operating system and software versions. No more “it works on my machine.”

## How to get started

You can try this out today by downloading and installing the convox CLI:

### OS X

```
$ curl -Ls https://install.convox.com/osx.zip > /tmp/convox.zip
$ unzip /tmp/convox.zip -d /usr/local/bin
```

### Linux

```
$ curl -Ls https://install.convox.com/linux.zip > /tmp/convox.zip
$ unzip /tmp/convox.zip -d /usr/local/bin
```

You’ll also need Docker installed locally. If you’re on OS X be sure to [sign up for the Docker for Mac beta](https://beta.docker.com/).

Once you have the prerequisites installed you can play around with our Rails example:

```
$ git clone git@github.com:convox-examples/rails.git
$ cd rails
$ convox start
```

With the app booted you can run `docker ps` to get a list of container IDs and then exec onto a container and run Rails commands:

```
$ docker exec -it <container ID> bash
$ rails g scaffold ...
$ rake db:migrate
```

Observe the changed files on your local filesystem. Try changing a file locally and observe the file change on the container.

Please [join our Slack](https://invite.convox.com), and let us know what you think about this feature. Bug reports, feature requests and patches are welcome on the [project repo](https://github.com/convox/rack).

<blockquote markdown="1">
  Discuss this on [Hacker News](https://news.ycombinator.com/item?id=11915854).
</blockquote>
