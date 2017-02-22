---
title: Resources
permalink: /guide/resources/
phase: deploy
---

Resources behave like services, but are external to your application. Your application communicates with these resources over a network.

Examples of typical resources used with Convox are data stores like RDS or redis, mailservers, and so on.

To illustrate this concept, we'll replace the `redis` service in [our example app](https://github.com/convox-examples/convox-guide/) with a hosted `redis` resource.

## Create our redis resource

Tell Convox to create the resource you want by running `convox resources create <resource type>`:

```
$ convox resources create redis 
Creating redis-2975 (redis)... CREATING
```

The resource will be created in the region of your currently active rack, as shown in `convox rack`.

It will take a few minutes for the resource to be created. To view the status, check the output of `convox resources`:

```
$ convox resources
NAME        TYPE   STATUS
redis-2975  redis  creating
```

Above, we can see that the new `redis` resource we created is running, and it's named `redis-2975`.

We can view the status and URL of our new `redis` resource by running `convox resources info <resource name>`:

```
$ convox resources info redis-2975
Name    redis-2975
Status  running
Exports
  URL: redis://der11wmx77bulki2.x6825x.ng.0001.use1.cache.amazonaws.com:6379/0

```

You'll see a variety of info about the resource, including the `URL`, which contains the redis credentials.


## Linking the resource to our app

Next, we need to update the `REDIS_URL` environment variable in our Rack containers with the URL we retrieved in the previous command. To do this, we'll use the `convox env set` command.

```
$ convox env set REDIS_URL=redis://der11wmx77bulki2.x6825x.ng.0001.use1.cache.amazonaws.com:6379/0
Updating environment... OK
To deploy these changes run `convox releases promote RSEUQJPZDSQ`

$ convox releases promote RSEUQJPZDSQ
Promoting RSEUQJPZDSQ... UPDATING
```

<div class="alert alert-info" markdown="1">
Note that the `env set` syntax is `FOO=bar`, not `FOO bar` or `FOO: bar`.
</div>

Now we can see the new environment variable on our Rack:

```
$ convox env get REDIS_URL
redis://der11wmx77bulki2.x6825x.ng.0001.use1.cache.amazonaws.com:6379/0
```

And (having gotten the container ID via `convox ps`) we can see it has been updated in the `web` container as well:

```
$ convox exec 95c2c7b2fd8e echo \$REDIS_URL
redis://der11wmx77bulki2.x6825x.ng.0001.use1.cache.amazonaws.com:6379/0
```

So we should scale our `redis` service, which we've just replaced with an external `redis` _resource_, down to 0:

```
$ convox scale redis --count=0
NAME    DESIRED  RUNNING  CPU  MEMORY
web     1        1        0    256
worker  1        1        0    256
redis   0        1        0    256
```


# Further reading

For more information on resources, see:

* [Resources](/guide/resources/) in the Convox docs
* [Resource linking](https://convox.com/docs/syslog#resource-linking) in the Convox docs
* `convox resources create --help`
* [The Twelve-Factor App: Backing services](https://12factor.net/backing-services){:target="_blank"}

{% include_relative _includes/next.html
  next="Monitor your app"
  next_url="/guide/monitor/"
%}
