---
author: Luke Roberts
date: 2016-09-30T00:00:00Z
title: Announcing Workflows
twitter: awsmsrc
url: /2016/09/30/announcing-workflows/
---

Today I'm pleased to announce that we're adding Workflows, a set of new Convox tools and APIs that enable DevOps best practices like Continuous Delivery and QA Apps.

With Workflows you can now automate the steps between new code and a production deploy. For example, you can build a Continuous Delivery workflow:

1. Push code to a GitHub branch
2. Trigger TravisCI tests to run and update GitHub branch status to “green”
3. Merge code to GitHub master
4. Trigger Convox to Build new Docker Images and release it to production

<!--more-->

On step 4, all the uptime guarantees of Convox kick in. New Images will be rolled out without dropping requests, and automatically rolled back if health checks do not pass. Your team can see all this activity with the Slack integration.

If your team is not yet ready to send every “master” update straight into production, you can build a QA App workflow:

1. Merge code to GitHub master
2. Trigger Convox to Build new Images and release them to a staging app
3. Trigger Convox to Build new Images (but not release them) to a production app

Now someone can verify the changes on the staging app, then promote them to production with a single `convox release promote` command.

## Why Workflows?

Docker Images are the best practice for packaging our applications. This is because Docker Images enable us to describe everything our app needs -- starting with the base operating system, then system dependencies, then app code -- and efficiently pull and push these packages around.

Automating how code is turned into a Docker Image, then what is done to verify and run that Image, is the future of cloud computing. Developers, cloud services, and software tools will speak the same language: workflows around Images.

Convox Workflows makes this a reality now.

## How Does it Work?

Workflows are built upon commands and APIs that are easy to understand:

| convox switch               | Switch between isolated Racks, e.g. staging and production |
| convox build                | Build new Docker Images and create a Release Candidate     |
| convox releases promote $ID | Promote a Release Candidate                                |

We are now introducing a Workflow Builder that uses these APIs. Here you can use a simple UI to automate how Images are built and released across Racks and Apps:

![Workflow Builder](/assets/images/workflow-builder.png){: .center }*Workflow Builder*

When you can automate how to build Images and how to release them to Racks and Apps extremely sophisticated workflows are possible.

What workflows can you imagine? What types of tasks can Convox add to the Workflow Builder to make this a reality?

To learn more about setting up and using Workflows, read the [Console Workflows](https://convox.com/docs/workflows/) documentation.