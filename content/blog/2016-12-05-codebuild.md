---
author: Noah Zoschke
date: 2016-12-05T00:00:00Z
subtitle: Cheaper, Faster, Safer Builds
title: AWS CodeBuild
twitter: nzoschke
url: /2016/12/05/codebuild/
---

A few months ago I wrote *[AWS Missing Parts: Build Service](https://convox.com/blog/aws-missing-build-service/)*. At the 2016 re:Invent conference, AWS launched [CodeBuild](https://aws.amazon.com/codebuild/), a service to “build and test code with continuous scaling.”

![[Werner Vogels re:Invent 2016 Keynote](https://www.youtube.com/watch?v=ZDScBNahsL4&t=34m48s) — Code Build Announcement](https://medium2.global.ssl.fastly.net/max/5108/1*F3Ggj41jsDImvFTjGXZN7Q.png)*[Werner Vogels re:Invent 2016 Keynote](https://www.youtube.com/watch?v=ZDScBNahsL4&t=34m48s) — Code Build Announcement*

I’m very excited that AWS filled in this gap in their platform. CodeBuild enables us to further simplify our systems, letting AWS do all the hard work of securing and operating the build step in our software delivery pipeline.

<!--more-->

## Why Builds?

Every software delivery pipeline has to take source code from a developer’s laptop and safely ship it to production systems in the cloud.

This is best accomplished by “building an artifact” — a snapshot of the code and everything it needs to run like its dependencies and compiled binaries.

Artifacts could be a .zip file, .deb package, AMI or a Docker image. Where and how to prepare these artifacts is an open-ended architectural decision.

## Why a Build Service?

The philosophy of “Services over Software” applies to the build phase of software delivery.

If we use **build software** like Jenkins or Bamboo, someone on our team is responsible for:

* Setting up a Jenkins cluster
* Maintaining the cluster security
* Upgrading the Jenkins software over time
* Monitoring and recovering from Jenkins downtime
* Capacity planning so the cluster can handle all our build volume

If you’re not careful you end up paying engineers to build and maintain a Jenkins cluster, and paying a big bill to keep the cluster scaled up 24/7. When the build cluster has problems, your team isn’t able to ship new code until it’s fixed.

With a **managed build service** like Heroku, Docker Hub, and now CodeBuild, operations are eliminated and costs are greatly reduced to on-demand usage. Your team is now empowered to just focus on pushing code, and let a service build all the artifacts.

AWS CodeBuild offers additional benefits:

* GitHub / Docker / Registry integration — Use modern standards
* Security — Sandbox untrusted builds
* Cost — Pay only for what you use
* Consolidation — Keep code, artifacts and billing in AWS

## Next Steps: Simplify

Up until now, the Convox platform offered a private build service running inside an existing ECS cluster ([architecture diagram](https://convox.com/assets/images/build%20sequence%20diagram.png)). We now get to simplify the platform by delegating builds to CodeBuild:

![Simple Build Architecture](https://medium2.global.ssl.fastly.net/max/2468/1*q8VCDvua49Yn1ZRUble45w.png)*Simple Build Architecture*

We expect to see tangible platform improvements from this. Builds will be:

* Cheaper by paying only for builds on demand
* Faster by no longer sharing resources inside an ECS cluster
* More concurrent by delegating capacity planning to CodeBuild
* More secure by removing privileged operations from the ECS cluster

What do you think? Are you already using a build service? Can you simplify your build system by letting AWS CodeBuild do all the heavy lifting?

Tweet at [@goconvox](https://twitter.com/goconvox) or [chat with us in Slack](http://invite.convox.com/).
