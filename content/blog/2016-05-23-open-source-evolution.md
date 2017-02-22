---
author: Noah Zoschke
date: 2016-05-23T00:00:00Z
title: The Open Source Evolution
twitter: nzoschke
url: /2016/05/23/open-source-evolution/
---

I feel incredibly lucky to get to use, build and think about open source software every day at Convox. I find it challenging and rewarding building a business around an open source software project.

I’d like to share my thoughts about the open source ecosystem right now, where I see it going in the future, and how Convox navigates the open source and cloud services ecosystem.

<!--more-->

## Open Source Software → Utility Computing

We all pay water, gas, and electric utility bills every month. We barely think about all the infrastructure that lets us take a hot shower for pennies. We have zero loyalties to the companies that process the fossil fuels that turn into gas, heat, and electricity. If anything goes wrong, we are confident that we can call a technician who will restore service quickly and cheaply with standard parts available at any hardware store.

These “utilities” and “commodities” are possible by decades of companies competing to build and perfect complex infrastructure.

Cloud Computing is heading this way.

Amazon, Google and Microsoft are using decades of expertise and massive bank accounts to build and run data centers that are leased to all of us for pennies per hour.

We know their systems are largely built on top of open source software:

* Linux, BSD, Solaris

* KVM, Xen, LXC, Docker

* Kubernetes, Mesos

* Java, Python, Golang, .NET Core

And we all use open source tools to interface with the cloud systems:

* Boto, Terraform, Ansible, Chef, Docker

* CloudFoundry, OpenStack, OpenShift, Deis, Convox

And we all use the clouds to run the software we built with open source:

* Git

* Ruby, Rails, Python, Django, Node.js, PHP, Golang

* Apache, nginx, HAProxy

* Postgres, MySQL, Redis, MongoDB

Open source is so pervasive it's easy to forget how much is in the stack.

This is what the commoditization of computing looks like. The supply chain for building and running software is increasingly solved and the component solutions are all open source. 

A large majority of these components are free (both as in beer and in speech) to take a use however needed. But not all. For pragmatic reasons, our own software and the open source software we adopt integrate with utility cloud services that are closed systems that must be leased.

Still this is great. Open source won, and we found one very agreeable model for renting and leasing utility infrastructure services. 

With open source software and utility cloud services we now all have the tools to accomplish anything.

## Philosophical Open Source

The grandfather of all open source licenses is the GNU Public License (GPL). Part legal contract, part philosophy, the GPL was a radical shift in how people built software. GPL code has to be public and free to use and modify.

GPL has been called “viral”. If you take a GPL code base and modify it for your needs and distribute that to users, you **have** to license the code changes GPL and distribute them publicly too.

This is “viral” in the best sense. Linux embraced this license. This philosophy has attracted incredibly smart people that all share the goal of building a truly free operating system as a computing foundation available for all. The model works incredibly well, and today Linux is the most important operating system in the cloud.

## Pragmatic Open Source — Services

Despite this massive success in Linux there is less and less GPL licensed code in the cloud stack showing up.

One intriguing cause here is the rise of Cloud Services in general. When you run software as a service you are not necessarily “distributing software”. Therefore modifications do not necessarily need to be made public.

Amazon and Google do take massive advantage this “loophole”. These companies integrate lots open source software but keep the vast majority of their business software private. Their code bases are serious competitive advantages between each other and against incumbents.

For example, AWS EC2 is built on the GPL [Xen Hypervisor](https://en.wikipedia.org/wiki/Xen) that surely has massive modifications for their unique product and engineering needs. And AWS ELB is built on the GPL [HAProxy](http://www.haproxy.org/) software. While AWS certainly does contribute back to these projects they aren’t beholden to virally making all their EC2 and ELB software public.

This is OK. The philosophy of GPL is a powerful concept, but companies like AWS or Google get a big break for dealing with the realities of running infrastructure at scale and making it available to all of us. We demand cheap and always available compute, network, data and email. Open source code purity matters less.

## Pragmatic Open Source — Permissive

Many “new” open source software projects adopt the “more permissive” BSD or Apache licenses that do not have the “viral” clause that require changes be re-distributed.

This open source software is incredibly free. The service loophole is fine. Forking, closing and selling software based on the parent project is allowed and even encouraged.

Convox uses the Apache 2 license for this reason. If you find bits or the entirety of our software useful to solve your problems take it! We do the same from other open source software projects.

## Pragmatic Open Source — Convox

Pragmatism is a core value of the Convox team and project. It permeates why and how we are working to unlock the true utility of the cloud. 

This is demonstrated in [The Convox Philosophy](https://convox.com/docs/):

> **Open Over Closed**
> We believe in open source. We believe you should be able to inspect and modify the software you depend on to run your business. We believe in open standards and transparency.
> 
> **Integration Over Invention**
> We believe in using existing open source technology that already exists whenever possible. On top of that we would much rather consume a quality service than run a piece of software.

Some ways this manifests:

* Convox is [Apache 2 licensed](https://github.com/convox/rack/blob/master/LICENSE), so you can always read and modify the tools between your business services and cloud infrastructure

* Convox is [developed on GitHub](https://github.com/convox/rack) so you can report issues, discuss design, [improve docs](https://github.com/convox/site) and [see a log of releases](https://github.com/convox/rack/releases)

* Convox heavily leverages the expertise built into Golang, Docker and AWS to build a simple development and production platform

We want Convox to be a great way for you to get infrastructure expertise while retaining freedom and control.

## The Future

Open source won. Open, free and transparent software projects will continue to dominate the way we all build and run software on the internet.

However, as cloud computing marches towards a utility service the vast majority of the software we write and the open source software we adopt will lease utility cloud services for very pragmatic reasons.

This started years ago around AWS S3. Important open source infrastructure like RubyGems and the Docker Registry happily delegate storage responsibilities to S3 so they can focus on building great tools and APIs and not worry about tough challenges around data durability.

Convox is working to advance this trend. The Convox project is developed in the open for all the philosophical reasons. But we embrace the pragmatism of leveraging cloud services when possible provided they hit an acceptable quality and cost bar.

This presents a pragmatic approach to all of us. You can maximize the time you spend writing business software and minimize the time worrying about infrastructure by:

* Building your business software on top of open source technology

* Delegating the boring parts of configuring cloud infrastructure to open source infrastructure tools like Convox

* Paying for the utility cloud services, built largely on open source, that your infrastructure tools leverage

You’ll know you’re in the future when:

* Your development team is shipping bug fixes and features that make your customers happy daily

* The platform below is largely invisible

* The infrastructure is automatically getting more reliable and affordable over time
