---
title: "Scaling"
order: 800
---

Convox allows you to scale your application's concurrency, memory allocation, and the resources available in the underlying Rack.

### Scaling an application

#### Show current application scaling

```
$ convox scale
NAME  DESIRED  RUNNING  MEMORY
web   2        1        256
redis 1        1        256
```

#### Concurrency

```
$ convox scale web --count=4
NAME  DESIRED  RUNNING  MEMORY
web   2        1        256
```

#### Memory

```
$ convox scale web --memory=1024
NAME  DESIRED  RUNNING  MEMORY
web   2        1        1024
```

#### CPU

Each rack instance has 1,024 [cpu units](http://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html#ECS-Type-ContainerDefinition-cpu) for every CPU core. This parameter specifies the minimum amount of CPU to reserve for a container. Containers share unallocated CPU units with other containers on the instance with the same ratio as their allocated amount.

```
$ convox scale web --cpu=1024
NAME  DESIRED  RUNNING  CPU
web   1        1        1024
```

#### Scaling down unused services

It's often convenient to run a service like Redis in a container locally. You can do so by defining a `redis` process in your `docker-compose.yml`. However, when you've deployed the app to your rack, you should use a hosted resource like ElastiCache. In this case, you can scale redis down and destroy the ELB which was created:

```
$ convox scale redis --count=-1
NAME  DESIRED  RUNNING  MEMORY
redis   -1        1        256
```

Note: If you scale this service back up, the ELB will be recreated, but will have a different domain name associated with it. If you want to scale a service down, but keep the ELB, you can set `--count=0`.

### Scaling the Rack

You can define both the type and count of instances being run in your Rack.

```
$ convox rack scale --type=m4.xlarge --count=3
Name     demo
Status   updating
Version  20160409181028
Count    3
Type     m4.xlarge
```
<div class="block-callout block-show-callout type-warning" markdown="1">
  The minimum instance count for a Rack is 3. See the [PR](https://github.com/convox/rack/pull/1395#issuecomment-261961713) for details.
</div>

#### Autoscale

Your Rack can scale its own instance count based on the needs of the containers it provisions. To use this command, set the `Autoscale` parameter:

```
$ convox rack params set Autoscale=Yes
```

To monitor for autoscaling events, use `convox rack logs` with the `--filter` option.

```
$ convox rack logs --filter="autoscaleRack change="
```
