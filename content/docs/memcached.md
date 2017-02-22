---
title: "Memcached"
---

## Resource Creation

You can create Memcached instances using the `convox resources create` command:

    $ convox resources create memcached
    Creating memcached-5864 (memcached)... CREATING

This will provision Memcached on Amazon ElastiCache. Creation can take a few minutes. To check the status use `convox resources info <resource-name>`.

### Additional Options

| Option                            | Description                                         |
| --------------------------------- | --------------------------------------------------- |
| `--instance-type=<instance.type>` | Elasticache instance type\* to use                  |
| `--name=<name>`                   | Name of the resource to create                       |
| `--num-cache-nodes=<n>`           | Number of cache nodes the cache cluster should have |
| `--private`                       | Create in private subnets                           |

\* See [Available Elasticache node types](https://aws.amazon.com/elasticache/details/#Available_Cache_Node_Types)

## Resource Information

To see relevant info about the Memcached instance, use the `convox resources info` command:

    $ convox resources info memcached-5864
    Name    memcached-5864
    Status  running
    Exports
      URL: dev-ca-m3z4ik3n7bej.77prpt.cfg.use1.cache.amazonaws.com:11211

## Resource Linking

You can add this URL as an environment variable to any application with `convox env set`:

    $ convox env set MEMCACHED_URL='dev-ca-m3z4ik3n7bej.77prpt.cfg.use1.cache.amazonaws.com:11211' --app example-app

## Resource Deletion

To delete the resource, use the `convox resources delete` command:

    $ convox resources delete memcached-5864
    Deleting memcached-5864... DELETING

Deleting the resource will take several minutes.

<div class="block-callout block-show-callout type-warning" markdown="1">
This action will cause an unrecoverable loss of data.
</div>
