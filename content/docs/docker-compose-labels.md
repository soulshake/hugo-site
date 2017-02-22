---
title: "Docker Compose Labels"
---

Convox uses [Docker Compose Labels](https://docs.docker.com/compose/compose-file/#/labels) to add metadata to containers. These labels serve as a convenient way to specify Convox-specific configuration alongside the rest of your more standard container configuration.

<pre>
labels:
  - <a href="#convoxcron">convox.cron.&lt;task name&gt;</a>
  - <a href="#convoxdeployment">convox.deployment.maximum</a>
  - <a href="#convoxdeployment">convox.deployment.minimum</a>
  - <a href="#convoxhealth">convox.health.path</a>
  - <a href="#convoxhealth">convox.health.port</a>
  - <a href="#convoxhealth">convox.health.timeout</a>
  - <a href="#convoxidle">convox.idle.timeout</a>
  - <a href="#convoxport">convox.port.&lt;number&gt;.protocol</a>
  - <a href="#convoxport">convox.port.&lt;number&gt;.proxy</a>
  - <a href="#convoxport">convox.port.&lt;number&gt;.secure</a>
  - <a href="#convoxstart">convox.start.shift</a>
</pre>

## convox.cron

The `convox.cron` label allows you to schedule recurring tasks for any of your apps. The following example would run a task named `myjob` at 6:30pm UTC every weekday.

    labels:
      - convox.cron.myjob=30 18 ? * MON-FRI bin/myjob

See our [scheduled tasks documentation](/docs/scheduled-tasks) for more.

## convox.deployment

The `convox.deployment` labels allow you to fine-tune how ECS manages your deployment.

    labels:
      - convox.deployment.minimum=100
      - convox.deployment.maximum=200

Both `minimum` and `maximum` are percentages relative to the desired count for a given process. If your application has a `web` process scaled to a desired count of 4, a `minimum` of 100 would instruct ECS to keep at least 4 `web` processes (or "tasks" in ECS terms) running throughout a deployment. A `maximum` of 200 would allow ECS to run up to 8 processes: 4 old processes and 4 new processes starting up, before ECS kills the old ones.

If you'd like a more in-depth explanation, see the ECS doc [Updating a Service](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/update-service.html).

## convox.health

During [rolling updates](/docs/rolling-updates), Convox will attempt to start a new process and check its health before stopping an old process. These labels allow you to customize the path on your app that will respond to the health checks, the port on which the app will listen for the health check, and the number of seconds Convox should wait for a health check response before giving up and trying again.

    labels:
      - convox.health.path=/health_check
      - convox.health.port=3001
      - convox.health.timeout=60

## convox.idle

To customize the [idle timeout of an ELB](http://docs.aws.amazon.com/elasticloadbalancing/latest/classic/config-idle-timeout.html), set the `convox.idle.timeout` to a number of seconds between 1 and 3600. Convox defaults to 3600.

    labels:
      - convox.idle.timeout=3000

## convox.port

Use these labels to configure load balancer behavior on specific ports.

    labels:
      - convox.port.<number>.protocol=tls
      - convox.port.<number>.proxy=true
      - convox.port.<number>.secure=true

See our [load balancer documentation](/docs/load-balancers) for more.

## convox.start.shift

_See also: [the `--shift` flag](/docs/running-locally/#shifting-ports)_

Use the `convox.start.shift` label to offset the external ports of processes run by `convox start` by a given number. This allows multiple applications to run on one host without conflicts. A container configured to listen on host ports 80 and 443 could be shifted to listen on ports 1080 and 1443 with the following configuration:

    labels:
      - convox.start.shift=1000
