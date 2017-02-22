---
title: "Convox Rack"
order: 200
---

Convox Rack is an [open source](https://github.com/convox/rack) deployment platform that is installed into your AWS account. A Rack creates and manages all of the underlying infrastructure needed to run and monitor your applications. A Rack is the unit of network isolation -- applications and services on a Rack can only communicate with other applications and services on the same Rack.

![](https://canvas-files-prod.s3.amazonaws.com/uploads/4187e38e-c6f9-4611-976e-f890c8ed464e/convox-rack-diagram.jpg)

### Rack API

Once installed your Rack will expose a simple [REST API](https://convox.com/api) for managing the Rack and its applications. This API is consumed by the [Convox CLI](https://dl.equinox.io/convox/convox/stable) and [Console](https://console.convox.com) or can be used to build your own workflows and automation.

### Dynamic Runtime

A Rack will start multiple identical servers on which it will containerize and run your applications. By using a homogenous runtime we can treat each individual server as disposable and recover easily from common failure scenarios.

### Private Network

Each Rack creates a private network inside which it runs its servers and services. All access from the internet comes through load balancers which are specifically configured route traffic to your containers.

### Resources

Backing resources such as [Postgres](/docs/postgresql), [MySQL](/docs/mysql), or [Redis](/docs/redis) can be easily installed into your Rack. Once installed, these resources are only accessible to applications running on that Rack. Convox resources are backed by powerful primitives in the underlying infrastructure such as [RDS](https://aws.amazon.com/rds/) and [ElastiCache](https://aws.amazon.com/elasticache/).
