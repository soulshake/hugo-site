---
title: "Redis"
---

## Resource Creation

You can create redis databases using the `convox resources create` command:

    $ convox resources create redis
    Creating redis-3785 (redis)... CREATING

This will provision Redis on the Amazon ElastiCache. Creation can take a few minutes. To check the status use `convox resources info`.

### Additional Options

<table>
  <tr><th>Option</th><th>Description</th></tr>
  <tr><td><code>--automatic-failover-enabled</code></td><td>Enable automatic failover (requires <code>num-cache-clusters > 1</code>)</td></tr>
  <tr><td><code>--instance-type=<b><i>cache.t2.micro</i></b></code></td><td>ElastiCache instance type to use</td></tr>
  <tr><td><code>--num-cache-clusters=<b><i>1</i></b></code></td><td>Number of cache clusters to create (one read-write, rest read-only)</td></tr>
  <tr><td><code>--name=<b><i>&lt;name&gt;</i></b></code></td><td>The name of the resource to create</td></tr>
  <tr><td><code>--private</code></td><td>Create in private subnets</td></tr>
</table>

## Resource Information

To see relevant info about the database, use the `convox resources info` command:

    $ convox resources info redis-3785
    Name    redis-3785
    Status  running
    URL     redis://atb1alu32d6lfy19.c63i2h.ng.0001.use1.cache.amazonaws.com:6379/0

## Resource Linking

You can add this URL as an environment variable to any application with `convox env set`:

    $ convox env set REDIS_URL='redis://atb1alu32d6lfy19.c63i2h.ng.0001.use1.cache.amazonaws.com:6379/0' --app example-app

## Resource Deletion

To delete the database, use the `convox resources delete` command:

    $ convox resources delete redis-3785
    Deleting redis-3785... DELETING

Deleting the database will take several minutes.

<div class="block-callout block-show-callout type-warning" markdown="1">
This action will cause an unrecoverable loss of data.
</div>
