---
title: SSL
permalink: /guide/ssl/
phase: run
---

SSL is a protocol that provides for the encryption of network traffic to and from your balancers.

Using SSL ensures the privacy and data integrity of your network communications.

To set up HTTPS, publish port 443 and add the label `convox.port.443.protocol=https` to your `docker-compose.yml`.

<pre class="file yaml" title="docker-compose.yml">
<span class="diff-u">version: '2'</span>
<span class="diff-u">services:</span>
<span class="diff-u">  web:</span>
<span class="diff-u">    build: .</span>
<span class="diff-u">    command: ["node", "web.js"]</span>
<span class="diff-a">    labels:</span>
<span class="diff-a">      - convox.port.443.protocol=https</span>
<span class="diff-u">    ports:</span>
<span class="diff-u">      - 80:8000</span>
<span class="diff-a">      - 443:8000</span>
<span class="diff-u">  worker:</span>
<span class="diff-u">    build: .</span>
<span class="diff-u">    command: ["node", "worker.js"]</span>
<span class="diff-u">    environment:</span>
<span class="diff-u">      - GITHUB_API_TOKEN</span>
</pre>

The Convox balancer will now listen for external HTTPS traffic on port 443, secure these connections using a self-signed cert, and forward requests to containers of the `web` service which have exposed port 8000.

Run `convox doctor` to validate your port protocol label and balancer definitions:

<pre class="terminal">
<span class="command">convox doctor</span>

### Run: Balancer
[<span class="pass">✓</span>] Application secured with SSL
[<span class="pass">✓</span>] Service <span class="service">web</span> port 443 responds to HTTPS
</pre>

Now that you have added SSL, you can [add a Database](/guide/databases/).

{% include_relative _includes/next.html
  next="Add a database"
  next_url="/guide/databases"
%}

