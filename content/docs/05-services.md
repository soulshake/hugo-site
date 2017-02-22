---
title: Services
permalink: /guide/services/
phase: build
---

{% include definitions/changes/warning.md %}

{% include definitions/service.md %}

Defining an app as a collection of services enables independent horizontal scaling of each service.

A service is defined in the `services:` section of `docker-compose.yml`.

<pre class="file yaml" title="docker-compose.yml">
version: '2'
services:
  # Redis producer
  web:
    build: .
    command: ["node", "web.js"]
  # Long-running Redis consumer
  worker:
    build: .
    command: ["node", "worker.js"]
</pre>

This `docker-compose.yml` specifies two services, `web` and `worker`. The `build` directives indicate that both services will use the same image--the one based on the `Dockerfile` in the current directory (`.`). The `command` directives specify the program to run against that image (the `node` HTTP server, in both cases).

<pre class="file js" title="web.js">
var http = require("http");
var redis = require("redis");

var client = redis.createClient(process.env.REDIS_URL);

var server = http.createServer(function(request, response) {
  console.log(request.method, request.url)

  client.rpush("queue", JSON.stringify(request.headers));

  response.writeHead(200, {
    "Content-Type": "text/plain"
  });
  response.end("Hello World!\n");
});

server.listen(8000);

console.log("web running at http://127.0.0.1:8000/");
</pre>

<pre class="file js" title="worker.js">
var redis = require("redis");

var client = redis.createClient(process.env.REDIS_URL);

var dequeue = function() {
  client.blpop("queue", 0, function(err, data) {
    console.log(data)
    dequeue()
  })
};

client.on('connect', dequeue);

console.log("worker running");
</pre>

If you haven't already, write a `docker-compose.yml` that specifies the services that define your app, as in the example above.

Then, run `convox doctor` to validate your service definitions:

<pre class="terminal">
<span class="command">convox doctor</span>

### Build: Service

[<span class="pass">✓</span>] docker-compose.yml found
[<span class="pass">✓</span>] docker-compose.yml valid
[<span class="pass">✓</span>] docker-compose.yml version 2
[<span class="pass">✓</span>] Dockerfiles found
[<span class="pass">✓</span>] Service <span class="service">web</span> is valid
[<span class="pass">✓</span>] Service <span class="service">worker</span> is valid
</pre>

Now that you have defined your app's services, you can [define your environment to configure how the services run](/guide/environment/).

{% include definitions/changes/process-to-service.md %}

{% include_relative _includes/next.html
  next="Define your environment"
  next_url="/guide/environment"
%}

