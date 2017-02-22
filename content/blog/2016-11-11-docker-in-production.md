---
author: Noah Zoschke
date: 2016-11-11T00:00:00Z
title: Docker In Production for 18 Months
twitter: nzoschke
url: /2016/11/11/docker-in-production/
---

There is a wave of Docker retrospectives out there right now. A couple are negative:

- [Docker in Production: A History of Failure](https://thehftguy.wordpress.com/2016/11/01/docker-in-production-an-history-of-failure/)
- [Docker in Production: A retort](http://patrobinson.github.io/2016/11/05/docker-in-production/)

And one is positive:

- [Running Docker in Production](http://racknole.com/blog/running-docker-in-production-for-6-months/)

I'd like to add my positive perspective...

I’m sitting here at Convox looking over thousands of production servers where Docker is a huge part of the success.

How can this be?

<!--more-->

## Don’t Do-It-Yourself

Building a custom deployment system with any tech (Docker, Kubernetes, Ansible, Packer, etc.) is a challenge. All the small problems and subtle decisions add up to one big burden on you.

6 months later, when things aren't totally stable, you get very angry about all the time wasted and blame the tools.

The cost of DIY over the life of a business is massive. You need at a bare minimum one full-time DevOps Engineer to build and maintain things. But if your business systems are growing, you'll need a whole team to keep things humming 24/7.

Instead, pick an existing platform and teach your Developers to embrace the constraints and your DevOps Engineers to use the platform support as force multiplier.

The ["Just Use Heroku" Rant](https://circleci.com/blog/its-the-future/) is still standing strong.

We set out to build [Convox](https://convox.com/) as an internal deployment system so you don't have to.

## Don't use all of Docker

Docker images, containers and logging drivers are simple and great. Docker's sweet spot is process management with universal APIs and security baked in.

Volumes, networks and orchestration are complex. There is plenty of success with these parts, but not without overcoming serious challenges.

I give tons of credit to Docker for attacking the challenges in this part of the stack. It's leading up to great things. But a conservative approach to these tools is wise.

## Use Services, Not Software

One of the articles says Docker is "Banned from the DBA". My Database administrator is the ace teams behind AWS DynamoDB and Heroku Postgres that work non-stop to protect my data.

Configuring an AWS VPC is far simpler than mastering the Docker networking stack. Using ECS is much easier than maintaining your own etcd or Swarm cluster. Using Cloudwatch Logs is cheaper and more reliable than deploying a logging contraption into your cluster.

## A Recipe For Success

If you do need to run Docker in production yourself, this recipe is working well for us at Convox:

* ECS Optimized AMI for the OS
    * Amazon Linux
    * Linux Kernel 4.4
    * Docker 1.11
    * DeviceMapper Storage Driver

* AWS VPC for private networking

* AWS RDS or DynamoDB for application state
    * Experimental container persistence w/ EFS

* AWS ECR for storing/deleting Docker Images

* AWS CloudWatch Logs for saving and searching logs
    * Docker awslogs driver

## Conclusion

If you are starting a new business you should not take on building a deployment system as part of your numerous challenges.

Use an expertly-built and peer-reviewed platform like Heroku, Elastic Beanstalk or Convox. Docker (and containers in general) play a big part of these platforms, but is a means to an end.

<blockquote markdown="1">
  Discuss this on [Hacker News](https://news.ycombinator.com/item?id=12932189).
</blockquote>
