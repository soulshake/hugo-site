---
author: Noah Zoschke
date: 2016-09-21T00:00:00Z
title: 'AWS Missing Parts: Build Service'
twitter: nzoschke
url: /2016/09/21/aws-missing-build-service/
---

Every modern software delivery system has a build step. This is where we:

* Clone app source code
* Download the app dependencies
* Zip everything together
* Upload the artifact to a storage service

This artifact is what will be deployed to our production servers.

Building this artifact in an isolated step provides safety. If something goes wrong, say we fail to fetch dependencies from Ruby Gems, the build will fail and there will be no artifact to deploy. This also provides deployment speed. We can build once, which might take a while due to compilation time, then deploy a single artifact to many servers in parallel.

Even though this is a required step, there is no fully-managed build service available on AWS.

To fill in the gap we can design our own simple build service on top on the EC2 Container Service (ECS) and the EC2 Container Registry (ECR).

<!--more-->

## Build and Packaging Options

There are many choices for a build archive format and storage service:

* AMI snapshotted on EBS
* .tgz file in S3
* .deb file in an APT repository like Ubuntu Launchpad
* Docker Image on Docker Hub
* Docker Image on ECR

There are many choices for where to run the build process:

* Our laptop
* A CI service like Travis or CircleCI
* A 3rd-party build service like DockerHub or Launchpad
* A Platform-as-a-Service like Heroku
* An EC2 Instance
* An ECS Cluster

The design goal of keeping everything in a single, secure AWS account eliminates most choices. 

Containers are the best practice for running application workloads in isolation, which eliminates building AMIs on EC2.

We’re left with a very reasonable choice to use the ECS to build Docker Images and push them to the ECR.
 
A build service is where ECS really shines. We can use a single ECS cluster to:

* Run a single Build API web server
* Run many one-off builds
* Use the local Docker daemon to build and push images

The same ECS cluster can also be used to deploy and run our build artifacts, but that’s another tutorial.

## Build Service API

We can design a simple REST API to offer basic needs:

| GET  /builds           | List the completion status of recent build tasks
| POST /builds           | Enqueue a build task for the give app source and return a task ID
| GET  /builds/{id}      | Get the completion status of a build task
| GET  /builds/{id}/logs | Stream an active build task logs

This API is designed to execute a long-running build as asynchronous tasks, block while streming its logs, then check the final status.

The POST handler needs the app source code. The simplest design is to accept a .tgz archive of the app directory in the POST form body. Then the handler will:

* Generate a unique build ID and save in DynamoDB
* Save the app source snapshot in S3
* Run an ECS task

## Build Task

The ECS task will carry out a simple build script:

* Get the app source snapshot from S3
* Unzip the .tgz
* Run `docker build`
* Run `docker tag` with the unique build ID
* Run `docker push` to upload the image to ECR
* Update DynamoDB with the completion status

## Putting It All Together

The API and one-off build containers run on ECS and leverage the Docker daemon. The build upload is passed from the API to the build task via S3. ECR stores the final Docker Image. DynamoDB saves a record of the build ID and it's final status.

![Build Sequence](/assets/images/build sequence diagram.png){: .center }*Build Sequence*

![Build Infrastructure](/assets/images/build block diagram.png){: .center }*Build Infrastructure*

Even though AWS doesn’t have a dedicated build service, we can design a simple one on top of the other AWS managed services.

---

This very same build architecture powers the `convox build` and `convox deploy` commands. If you want an easy way build and store Docker Images with in a private ECS and ECR service, `convox install` will get you running in minutes.

For more cloud architecture discussion, follow [@nzoschke](https://twitter.com/nzoschke) and [@goconvox](https://twitter.com/goconvox) on Twitter.