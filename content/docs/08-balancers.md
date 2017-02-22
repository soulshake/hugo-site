---
title: Balancers
permalink: /guide/balancers/
phase: run
---

A _balancer_ is a stable network endpoint that distributes traffic to the individual containers of a service.

<div class="block-callout block-show-callout type-info" markdown="1">
### General Docker patterns

A common pattern when using Docker Compose is to declare a simple web frontend service. For example, this might mean a container based on the `nginx` base image (perhaps called `web`, `lb`, `www`, or the like), to which a simple `nginx.conf` file is added.

This NGINX container then serves as a lightweight proxy or load balancer which passes web requests to the appropriate container using its service name, which in Compose resolves automatically to the internal IP of the corresponding container.

In other words, in general terms and in the Docker world, a balancer is a stable network endpoint that distributes traffic to the individual containers of a service, enabling you to interact with a service over the network without knowledge of the service's containers' internal IPs or the host they're running on.
</div>


## Convox Balancer

We built Convox with the goal of ensuring maximum similarity between development and production. Apps deployed with Convox are automatically assigned their own Elastic Load Balancer in production. To emulate this behavior locally, Convox starts a local proxy container that emulates the production ELB.

When you run `convox start`, this proxy container is automatically started and configured under the hood by looking at the `ports:` section of your `docker-compose.yml`:

<pre class="file yaml" title="docker-compose.yml">
<span class="diff-u">version: '2'</span>
<span class="diff-u">services:</span>
<span class="diff-u">  web:</span>
<span class="diff-u">    build: .</span>
<span class="diff-u">    command: ["node", "web.js"]</span>
<span class="diff-a">    ports:</span>
<span class="diff-a">     - 80:8000</span>
<span class="diff-u">  worker:</span>
<span class="diff-u">    build: .</span>
<span class="diff-u">    command: ["node", "worker.js"]</span>
<span class="diff-u">    environment:</span>
<span class="diff-u">     - GITHUB_API_TOKEN</span>
</pre>

An _internet_ balancer is defined by a pair of external and internal ports, e.g. `80:8000`. The balancer will listen to the internet on port `80` and forward requests to app containers that are bound to port `8000`.

An _internal_ balancer is defined by a single port, e.g. `8000`. The balancer will not listen to the internet, but will listen on port `8000` on the internal network and forward requests to app containers that are bound to port `8000`.

<div class="block-callout block-show-callout type-info" markdown="1">
For details on these two types of Elastic Load Balancers, see the AWS ELB documentation:

* [Internet-Facing Classic Load Balancers](http://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-internet-facing-load-balancers.html)
* [Internal Classic Load Balancers](http://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-internal-load-balancers.html)
</div>

The Convox balancer looks at your services' published ports and publishes those same ports itself instead, then automatically passes requests to those containers just as you would expect it to based on the contents of your `docker-compose.yml`. In this way, you're sure to get the same behavior when you run `convox deploy`, where a real ELB performs the same function.

Run `convox doctor` to validate your balancer definitions:

<pre class="terminal">
<span class="command">convox doctor</span>

### Run: Balancer
[<span class="pass">✓</span>] Application exposes ports
[<span class="pass">✓</span>] Service <span class="service">web</span> has valid ports
</pre>

Now that you have defined Balancers, you can [add SSL](/guide/ssl/).

{% include_relative _includes/next.html
  next="Add SSL"
  next_url="/guide/ssl"
%}

