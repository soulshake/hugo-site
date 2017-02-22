---
author: Noah Zoschke
date: 2015-08-12T00:00:00Z
title: Integration over Invention
twitter: nzoschke
url: /2015/08/12/integration-over-invention/
---

In 10 minutes [Convox](https://convox.com/) installs a system that takes over the management of your AWS servers, networking, and data and lets you deploy applications to the Internet with a single command.  

<!--more-->

The `convox install` command configures and integrates the latest and best AWS services to provide a production-ready infrastructure for your applications. CloudFormation, VPC, ASG, EC2, ELB, Kinesis, Dynamo, S3 and even Lambda play important parts of the system. With Convox the hard parts of researching, testing and integrating these services are already solved.

Then, the `convox deploy` command can put any [12-factor](http://12factor.net/) or Docker application onto AWS and on the Internet. The Convox build and release API and private Docker registry coordinate making the images and containers and load balancers. Again the tough parts of integrating these components are already solved.

Convox is open-source, available right now, and free to use. [Get started](http://docs.convox.com)!

## Why Convox?

Every engineering team deserves great internal tooling to build and deploy their core business services. The best engineering companies have the best internal platforms, enabling engineers to remain in the flow of shipping bug fixes and features and not worry about devops and servers.

The Convox team came together to solve two major problems with internal tooling. One is that building these bespoke internal systems is an expensive and distracting exercise in hiring, research, development and maintenance. Another is that the existing “private platform” options are composed of experimental software in questionable levels of maturity. Both paths can be a massive investment and result in a whole new class of problems for your team.

Convox has a clear vision for how to solve these problems and advance our industry: **“Integration Over Invention”**. 

The open-source Convox project integrates the best infrastructure services together in the simplest ways possible to give everyone a great experience deploying services. We do not see the need to re-invent tough infrastructure components like load balancers, container schedulers or highly available data stores when Amazon is running these as a service with proven reliability and scalability. 

We do see the need to integrate AWS services and other open source tools together to make them behave as a coherent and reliable platform.

Convox is an open-source project that solves these integration challenges for every developer and engineering organization that wants to deploy onto the best production infrastructure in the world.

## Integration Over Invention: EC2 Container Service

Tools and technology to run containers is an extremely hot space right now. Google set the precedent for how powerful grid computing tooling is with their proprietary Borg system. Heroku has been orchestrating application containers at scale for years. In no particular order, Mesos, Kubernetes, Docker Swarm, CoreOS, and Joyent Smart Data Center offer open-source solutions to this problem.

There is incredible engineering in these projects, but adopting one brings on new challenges. How do you bootstrap a distributed key-value cluster? How do you debug what happens when the instance clocks skew? How do you configure monitoring on these critical sub systems? Who wears the pager, and what do the failure and recovery scenarios look like? How do you hire a devops team to manage all this?

Convox universally avoids these hard problems by pushing them onto a service provider. When surveying the landscape of providers in this place, the choice is obvious to stick with the industry-leading AWS ecosystem and adopt their latest EC2 Container Service (ECS).

## Journey To ECS

The first version of Convox deployed applications by building Amazon Machine Images (AMIs) that run a single Docker container, and configuring an AutoScaling Group (ASG) to run a fixed number of EC2 instances behind an ELB. We still consider this design the best tested and most reliable way to run a service on the Internet, and strongly favor designs this simple.

Unfortunately we found this pipeline far too slow for agile development and continuous delivery. Building an AMI took 6 minutes even after complicated optimizations, totally destroying the development and deployment flow.

We considered strategies to deploy directly into AMIs. A tool like Ansible make the plumbing easy, but a fully automated solution would require writing a custom deployment controller, custom logic to handle errors and retries, and take extreme care to make deployments roll out perfectly every time.

Surely we shouldn’t have to write this system yet again… Is there a managed service we can integrate? Perhaps AWS Code Deploy is the key to a great AMI workflow.

But we are already set on containers for developing, packaging and running applications, we decided it was time to make the leap to Amazon’s latest release: ECS.

The ECS guides and docs make it clear how Convox can run and update containers with simple API calls, and let AWS deal with all the hard parts.

## How ECS Works

First, we create a Cluster of EC2 instances to run everything via CloudFormation. Then a _Create Task Definition_ API call registers a Docker Image and environment for an application and a _Create Service_ API call schedules the containers to start in the Cluster. 

ECS handles extremely complex parts of the service lifecycle:

*   Services are scheduled inside the Cluster on an Instance with adequate CPU and Memory shares
*   A Service is automatically rescheduled if it crashes or the underlying Instance is terminated  

*   A new Docker Image or environment change (Task Definition update) starts a new Service, waits for it to register with the ELB, and drain and terminate the old Service during a successful deployment  

*   The progress and history of all these events are available through API calls

Orchestrating all this is a massive challenge in distributed systems. Werner Vogels recently published a look [under the hood of ECS](http://www.allthingsdistributed.com/2015/07/under-the-hood-of-the-amazon-ec2-container-service.html) with more details about the Paxos-based key/value Amazon uses to accomplish this.

Having managed the orchestration service at Heroku, and experimented with configuring and operating the numerous open-source orchestration systems, we are relieved that Amazon's world-class engineering tackled this problem and offers it to everyone as a service.

On ECS, deploys take seconds and always work.

## Conclusion

By letting ECS manage all the containers, Convox can focus on its core product: a simple API and CLI with a great experience for managing apps, builds, releases and logs.

By integrating ECS and other AWS services in the open-source Convox project, we can all minimize engineering efforts on these hard and boring parts. When using CloudFormation, ECS, Kinesis, Lambda, etc. correctly, we let Amazon shoulder all development cost of scalable architecture, and the operations cost of running highly-available services at scale.

With Convox and the "Integration Over Invention" approach, we can all get back to focusing solely on building and deploying our core business applications.

We invite you to [install Convox](http://docs.convox.com) to deploy your first app, and [contribute to the open-source project](https://github.com/convox/).
