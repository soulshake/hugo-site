---
title: Opendoor
layout: case
---

## The Challenge: Creating the definitive price index for real-estate

Fair and accurate pricing of residential real-estate underlies [Opendoor’s](https://www.opendoor.com/) core product. To develop their valuation models, Opendoor’s team of engineers and data scientists are constantly exploring new ideas to accurately estimate housing prices.

To support these rapid iterations, their team needs a platform that can deploy complex data science applications with ease and efficiency, and not worry about what platform constraints might get in the way.

## The Solution: Advanced Convox Configurations

Opendoor depends on two Convox Racks (see: [What Is A Rack?](https://convox.com/docs/rack/)). These Racks are peered together and with an existing AWS VPC. The two Racks make it easy for different engineering groups to run wholly different classes of experiments. The VPC peering makes it easy to move data around securely.

Opendoor first tested out Convox on one of their data science applications in Python. The benefits of the memory configuration options on Convox were immediate for their memory hungry (14+ GB) Python workers. Opendoor can configure Convox to meet their needs, instead of writing their app to fit a platforms constraints. They are now using 2 Racks for their 10+ apps.

> Both lightweight and straightforward to use, Convox has enabled Opendoor to deploy quickly and easy.
>
> It removes the stress and uncertainty of packaging our code for production, and provides a simple interface that encapsulates the full power and flexibility of EC2.
>
> Going to production is just a `convox deploy` away.
>
> -Ian Wong

More details about Opendoor's migration to Convox are on the [Moving Opendoor's Data Science stack from Heroku to Convox](https://labs.opendoor.com/moving-opendoors-data-science-stack-from-heroku-to-convox) blog post.

## The Architecture

* Multiple Racks for massive amounts of memory for any number of apps
* VPC peering for secure data pipelines

## About Opendoor

Opendoor, the online marketplace for homes, removes all of the headache, uncertainty and risk from buying and selling real estate. It is redefining how real estate is transacted, transforming a more-than-two month process into an instant and frictionless experience. Instead of dealing with the hassle of listing and showings, homeowners can visit [opendoor.com](https://opendoor.com), receive a guaranteed offer and complete their sale in a few clicks. For home buyers, the buying process is equally simple. For showings, buyers are able to visit homes themselves, on their schedule.

Opendoor has raised $110MM in financing, and employs over 130 creative individuals across San Francisco, Phoenix, Dallas and Las Vegas. The company has been featured in Fortune and The Wall Street Journal.
