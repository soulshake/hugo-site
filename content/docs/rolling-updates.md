---
title: "Rolling Updates"
order: 400
---

When a Release is promoted, new processes are gracefully rolled out into production.

If there are errors starting new processes, new processes are not verified as healthy, or the rollout doesn't complete in 10 minutes, an automatic rollback is performed.

The number of new processes started at a time is configurable so large apps can be fully rolled out in 10 minutes.

Rollouts and rollbacks do not cause any service downtime.

#### Rollout

A rollout coordinates starting new processes in a way that maintains service uptime and capacity. The basic flow is:

* Start 1 new process
* Verify new process is healthy
* Stop 1 old process
* Repeat for all processes in the formation

#### Automatic Rollback

If there are errors starting new processes, new processes are not verified as healthy, or the rollout doesn't complete in 10 minutes, an automatic rollback is performed. This will result in a `rollback` or `failed` state for the app:

```
$ convox apps info
Name       httpd
Status     rollback

$ convox apps info
Name       httpd
Status     failed
```

#### Health Checks

If the Process does not [expose ports](/docs/port-mapping) it is considered healthy if it starts and doesn't immediately exit or crash.

If the Process [exposes ports](/docs/port-mapping) is it considered healthy after it:

* Registers behind a load balancer
* Passes a network connection health check

Common causes for not passing health checks are:

* The cluster does not have sufficient memory or CPU resources available to start a new process
* The cluster does not have sufficient instances where a new process port is not already reserved by an older release
* A process crashes immediately after starting due to a problem in the latest code
* A process takes too long to initialize its server and therefore fails a network health check

#### Configuring Deployment Parameters

By default, a process must boot and pass the network health check in 3 seconds. If your app takes longer to boot, you may need to increase this to 60 seconds by adding a label:

```yaml
version: '2'
  services:
    web:
      labels:
        - convox.health.timeout=60
      ports:
        - 443:5000
```

See the [load balancers](/docs/load-balancers) doc for more information about configuring the timeout as well as setting a custom health check port and HTTP path.

By default, 100% of the processes on the old release stay running and the same number of processes on the new release will attempt to start at once. As new processes are deemed healthy, old ones will be stopped.

If we want to spare no expense for the fastest deployment speed, we can scale a Rack to have enough capacity to run two releases of the app simultaneously. For example if your app needs 5 instances to support 5 web processes that expose ports, running 10 instances will guarantee fast deploys:

```bash
$ convox rack scale --count 10
```

If we can tolerate a temporary decrease in service capacity, we can configure an app to not require 100% of the old processes to stay running. For example we can say that we're ok stopping 50% of the old processes immediately to free up capacity for new processes:

```yaml
version: '2'
  services:
    web:
      build: .
      image: convox/rails
      labels:
        - convox.deployment.minimum=50
```

See the [deployment labels](/docs/docker-compose-labels/#convoxdeployment) doc for more information about setting a deployment minimum.

Most apps will not need to configure any of these settings to gracefully roll out.
