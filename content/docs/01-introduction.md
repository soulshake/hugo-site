---
title: Introduction
permalink: /guide/
---

Welcome to the Convox Guide, a set of best practices for developing, deploying and automating an app on the Convox platform.

If you plan to follow along, you'll want to <a href="https://console.convox.com/grid/signup" target="_blank">sign up for Convox</a> and [install the Convox Command Line Interface](/docs/installation).

# Our mission

We built Convox to address the challenge of implementing and automating container-based deployment pipelines.

Our goal is to make it easy to build a simple and consistent workflow that's easy for your entire development team to understand, use, and maintain.

The Convox CLI follows a philosophy of "Convention over Configuration" which leads to three **simple commands** to develop and deploy any app:

* `convox doctor` -- run checks to verify your app is portable from development to production
* `convox start` -- start a local development environment for your app
* `convox deploy` -- create and launch a cloud service architecture for your app

The Convox Platform follows a philosophy of "Integration Over Invention" which leads us to building the system on top of:

* [Docker](https://docker.com) and Docker Compose
* [Amazon Web Services](https://aws.amazon.com/)

Convox imposes carefully considered constraints on your application to help you take advantage of the best features of these tools while avoiding common pitfalls. This guide serves as an outline to those constraints, as well as a bit of detail about the underlying reasons behind them.

# Background

The guide and tools are informed by the hands-on experience the team and community at [Convox](https://convox.com) have gained by "Dockerizing" thousands of apps and deploying them to the AWS EC2 Container Service. Much of that experience is in turn based on years of hands-on experience working on and using the [Heroku](https://heroku.com) platform.

Many of the concepts in this guide will be familiar if you have experience with [Twelve-Factor Apps](https://12factor.net/), [Docker Compose](https://docs.docker.com/compose/overview/) and/or Infrastructure-as-a-Service.

Modern codebases might already pass many of the verifications performed by `convox doctor`. For those that don't, this guide can help.

## The five phases of software delivery

Container-based software delivery happens in five distinct phases, which can be thought of as a pipeline:

- **Build** portable images
- **Run** an app as a set of Services running on images
- **Develop** and verify changes to images interactively
- **Deploy** new images safely to production
- **Automate** additional verifications of images before production

This guide walks you through every key step of every phase. The companion tools do their best to automatically verify that your app adheres to these key concepts.

You will hit roadblocks where your app is deviating from these best practices--but you will hit these early on in the process and will be pointed towards likely solutions, which will save you endless frustrations in production.

# Get ready

If you haven't already, install the Convox Command Line Interface (see [Installation](https://convox.com/docs/installation/)).

Now run `convox doctor` to run the first checklist:

```
$ convox doctor

### Setup
[✓] Docker running
[✓] Docker version >= 1.9
[✓] Docker run hello-world works
[✓] Convox CLI up to date
```

<div class="alert alert-warning">
  <strong>Note: </strong>`doctor`, as run at this point in the guide, will eventually find errors. For now, let's just look at the output of the first section, `Setup`.
</div>

If you don't have Docker installed, `convox doctor` will point you to the [Installing Docker Guide](https://docs.docker.com/engine/installation/).

Now that you understand the five phases and have run your first checklist to test that your computer is set up, you can begin to [build your app](/guide/build/)!

{% include_relative _includes/next.html
  next="Build an app"
  next_url="/guide/build"
%}

