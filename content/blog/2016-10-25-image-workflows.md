---
author: Noah Zoschke
date: 2016-10-25T00:00:00Z
title: Image Workflows
twitter: nzoschke
url: /2016/10/25/image-workflows/
---

The "container era" that recently began is explained by one core belief: 

We--the entire community of developers, operators and infrastructure providers--desire "one true way" to package our application workloads.

Packaging is as old as computing itself. The universal `tar` command, short for "tape archive," was introduced in the seventh edition of Unix in 1979 ([wikipedia](https://en.wikipedia.org/wiki/Tar_(computing))). Many more package formats have been introduced in the subsequent decades.

![Dorothy Whitaker works in the National Oceanographic Data Center (NODC) magnetic tape library](/assets/img/NDOC_magnetic_tape_library.jpg){: .center }*[Dorothy Whitaker works in the National Oceanographic Data Center (NODC) magnetic tape library](https://en.wikipedia.org/wiki/Tape_library#/media/File:NDOC_magnetic_tape_library.jpg)*

<!--more-->

In 2013, Docker showed us something that no other package format offers: an [HTTP Image API](https://docs.docker.com/engine/reference/api/docker_remote_api_v1.24/#/3-2-images). Every package format offers an interface for online distribution. But Docker enabled us to pull an entire operating system, customize it, then push it back with a few HTTP calls. All of a sudden packaging looked more like programming than writing to a tape.

![Image Layers](/assets/img/image layers.png){: .center }*Image Layers*

The next decade of computing has been decided: **Build Docker Images**. How to do this is coming into focus.

1. A developer defines the recipe for an Image as code in her application codebase
2. On every code change, a service builds, tags and pushes new Image layers to an Image Registry

Next, use your imagination...

![Build Workflow](/assets/img/build workflow.png)*Build Workflow*

Service providers will fight to build and store our Image data forever at low costs with lots of security and access control baked in. They will provide increasingly simple ways to run our app Images online.

The Continuous Integration practitioners will run automated tests against every new Image for developer feedback. The Continuous Delivery practitioners will automate rolling out every verified Image to production.

DevOps teams will customize the Image pipeline to suit complex organizational and business needs. Chatbots, blue-green deploys, and metrics-based automation will control what Images are running where.

People, cloud services, and software tools will speak the same language: workflows around Images.
