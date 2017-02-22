---
author: Noah Zoschke
date: 2016-10-18T00:00:00Z
title: The Convox Guide
twitter: nzoschke
url: /2016/10/18/the-convox-guide/
---

Today I'm pleased to announce [The Convox Guide](https://convox.com/guide). 

This is a simple, step-by-step guide to true [dev-prod parity](https://12factor.net/dev-prod-parity) for any app.

Follow this recipe to "Dockerize" any app, so you can develop it locally and deploy it to AWS, exactly what Images and Containers promise.

Understand these well-designed constraints around what parts of Docker and AWS to use to keep your config files, laptop and cloud computing environments simple.

While this guide is heavily influenced by hands-on experience "Dockerizing" thousands of apps on the Convox platform, the goal of this guide is to make **every app** easier to develop and deploy, and to give **every team** a set of conventions to follow.

<!--more-->

## Introduction

The goal is simple: take any app, develop a change on your laptop, ship the change to production, and watch it run forever.

The tools are common: your git repo, a text editor, config files, scripts, and cloud services.

The real challenge is building a simple and consistent pipeline. One that's easy for your entire development team to understand and maintain. One that lets you focus 100% on your app features and quality, and not waste time setting up and debugging your laptop or cloud computing environments.

The design for such a system is simple. You want **single commands** to:

* Build and verify artifacts for your app
* Start a development environment to make new artifacts for your app
* Configure cloud services to run the artifacts online

There are many ways we could build this experience. This guide follows a philosophy of "Integration Over Invention" which leads us to building on top of:

* [Docker](https://docker.com)
* [Amazon Web Services](https://aws.amazon.com/)

This guide presents step-by-step instructions to "Dockerize" any app to build Images that can be:

* Verified
* Run locally with Docker for development
* Deployed to AWS for production

## How To Use

Start by reading the Introduction on [convox.com](https://convox.com/guide) or in [the open-source GitHub repo](https://github.com/convox/site/tree/master/_guide).

## Contributing

* Join the [Convox Slack](https://invite.convox.com) channel to ask questions from the community and team
* Open a [GitHub Issue](https://github.com/convox/guide/issues/new) for corrections or enhancements
* Initiate a [GitHub Pull Request](https://help.github.com/articles/using-pull-requests/) to submit patches

## More Soon

This is just a start. We are working with users and customers from all backgrounds to make the guide indespensible for building apps.
