---
author: Noah Zoschke
date: 2016-08-11T00:00:00Z
title: Services over Software
twitter: nzoschke
url: /2016/08/11/services-over-software/
---

A year ago, I described a strategy we use to build Convox: **[Integration over Invention](https://convox.com/blog/integration-over-invention/)**. This philosophy leads us to build a platform that integrates existing cloud services instead of building custom software.

This strategy has been a resounding success. The Convox platform is trusted by hundreds of companies to run mission critical apps with the strictest requirements for performance, security and scale.

Convox would simply not be this far along if we were building distributed systems software instead of using utility cloud services.

I’d like to re-affirm the big advantages of **using services** over writing **software**.

<!--more-->

## Rapid Prototyping

We built the first viable version of Convox with a few people and a few weeks. We’ve added countless features and onboarded hundreds of customers over the following months with only adding a few more engineers.

It’s much, much faster to learn how to use mature services than to write new software or to adopt and modify immature software projects.

I’ve seen good teams struggle to get a single Kubernetes cluster and Prometheus server working reliabiliy in the same time we’ve stood up hundreds of ECS clusters pumping data to CloudWatch Logs.

## Minimal Operations

A year in and I can’t point to a serious Convox outage.

We’ve certainly helped customers with problems like deploys getting stuck, logs going missing, AMI updates rolling back, and yes -- app downtime.

In the worst case -- self-inflicted app downtime -- the playbook is always the same: roll back the configuration change. With a single CloudFormation API call we easily go back to the last good Docker Image, ELB configuration, and process formation.

The root cause for the smaller issues have been problems with the underlying services like EC2, ECS, Lambda, and CloudFormation.

When Lambda is demonstrating a service degradation, we observe that some operations that depend on the service — say deploying a new version of our app — fails. However we have 100% trust that AWS will recover the service in due time without any intervention.

So by using services we can simply observe and wait.

We don’t have to page our DevOps team to fix complex problems like:

* Recovering a failed etcd node

* Re-sharding an overwhelmed InfluxDB cluster

* Reconciling bad Terraform state data

The ECS, CloudWatch Logs and CloudFormation services make these Amazon’s responsibility. Amazon keeps these services humming the vast majority of the time and they recover them quickly and fully from their internal problems.

## Utility Pricing

We all see that the cloud is turning into a utility. Just like you don’t worry about your water bill when you take a shower, or your petrol bill for a trip to the beach, you shouldn’t worry about your cloud bill when you stand up a new app.

This reality is already here by using the right cloud services.

CloudWatch Logs has **zero set up cost**, $0.50 per GB/month ingestion cost, and pennies of Lambda cost for analysis and/or forwarding.

We have been pushing log volumes at a scale that would make some 3rd party log vendors choke, and spending very little time and money to get it working.

The **total cost of ownership** -- research, development, maintainance and resource costs -- of the best cloud services can’t be beat.

## Easy Migrations

Service Oriented Architecture is an accepted best practice for any engineering organization.

Because the Convox internals see everything as a services, swapping them out has been straightforward.

When we started Convox, we integrated the Docker registry software since no other single-tenant registry option existed. In the past year we’ve transparently migrated all our users and their Docker Images over to ECR.

Likewise, for a while Convox used Kinesis for log streaming and processing. However when the native Docker CloudWatch Logs driver came out, we cut logging over to the easier service. We got to delete code, and gain features of log archival and search.

AWS just [announced a new Application Load Balancer](https://aws.amazon.com/blogs/aws/new-aws-application-load-balancer/) (ALB) service, and we're already laying plans. Convox can add an option to provision new ALBs, in addition to the existing ELBs, on an app deploy so anyone can test out the new service in production. If it works well, and offers real advantages like saving money and supporting HTTP/2, we'll can make ALB the default, and document how to migrate from ELB to ALB.

We can keep migrating like this forever.

## Leverage

It all comes down to accomplishing more by doing less. Huge parts of the infrastructure we need to run our applications are not unique, in fact they have become routine problems solved by cloud services.

AWS offers the best infrastructure services. GitHub and GitLab offer the best code services. Slack and HipChat offer the best notification service.

By integrating these services together, we can get a great experience at fair price without having to write or operate much software.

Our engineers aren't responsible for setting up, managing and troubleshooting virtual machines, containers, load balancing software, git repos and chat websockets. A trusted service provider is.

Instead our engineers can focus on writing the software that uniquely defines our businesses.
