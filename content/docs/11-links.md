---
title: Links
permalink: /guide/links/
phase: run
---

A _link_ is an explicit connection between a service and another service or Convox resource.

Adding a link enables network discovery by injecting environment variables with the hostname of the service or resource that is linked to.

A link is defined in the `links:` and `environment:` sections of `docker-compose.yml`. The `links:` section defines the relationship. In a simple Node.js app both the `web` and `worker` services link to the `redis` resource. Now in the development or production environment, Convox will inject the hostname and port of the `redis` resource into the `web` and `worker` environments as `REDIS_URL`.

<pre class="file yaml" title="docker-compose.yml">
<span class="diff-u">version: '2'</span>
<span class="diff-u">services:</span>
<span class="diff-u">  web:</span>
<span class="diff-u">    build: .</span>
<span class="diff-u">    command: ["node", "web.js"]</span>
<span class="diff-a">    environment:</span>
<span class="diff-a">      - REDIS_URL</span>
<span class="diff-u">    labels:</span>
<span class="diff-u">      - convox.port.443.protocol=https</span>
<span class="diff-a">    links:</span>
<span class="diff-a">      - redis</span>
<span class="diff-u">    ports:</span>
<span class="diff-u">      - 80:8000</span>
<span class="diff-u">      - 443:8000</span>
<span class="diff-u">  worker:</span>
<span class="diff-u">    build: .</span>
<span class="diff-u">    command: ["node", "worker.js"]</span>
<span class="diff-u">    environment:</span>
<span class="diff-u">      - GITHUB_API_TOKEN</span>
<span class="diff-a">      - REDIS_URL</span>
<span class="diff-a">    links:</span>
<span class="diff-a">      - redis</span>
<span class="diff-u">  redis:</span>
<span class="diff-u">    image: convox/redis</span>
<span class="diff-a">    ports:</span>
<span class="diff-a">      - 6379</span>
</pre>

Run `convox doctor` to validate your link definitions:

<pre class="terminal">
<span class="command">convox doctor</span>

### Run: Links
[<span class="pass">✓</span>] Resource redis exposes ports
[<span class="pass">✓</span>] Service web environment includes REDIS_URL
[<span class="pass">✓</span>] Service worker environment includes REDIS_URL
</pre>

Now try to run your app:

<pre class="terminal">
<span class="command">convox start</span>
redis  │ running: docker run -i --rm --name myapp-redis myapp/redis
redis  │ 1:M 15 Oct 21:38:44.893 * The server is now ready to accept connections on port 6379
web    │ running: docker run -i --rm --name 10-link-web -e REDIS_URL --add-host redis:172.17.0.2 -e REDIS_SCHEME=redis -e REDIS_HOST=172.17.0.2 -e REDIS_PORT=6379 -e REDIS_PATH=/0 -e REDIS_USERNAME= -e REDIS_PASSWORD=password -e REDIS_URL=redis://:password@172.17.0.2:6379/0 -p 0:8000 10-link/web node web.js
worker │ running: docker run -i --rm --name 10-link-worker -e GITHUB_API_TOKEN -e REDIS_URL --add-host redis:172.17.0.2 -e REDIS_SCHEME=redis -e REDIS_HOST=172.17.0.2 -e REDIS_PORT=6379 -e REDIS_PATH=/0 -e REDIS_USERNAME= -e REDIS_PASSWORD=password -e REDIS_URL=redis://:password@172.17.0.2:6379/0 10-link/worker node worker.js
web    │ web running at http://127.0.0.1:8000/
worker │ worker running
web    │ GET /
worker │ [ 'queue',
worker │   '{"host":"localhost","user-agent":"curl/7.43.0","accept":"*/*"}' ]
</pre>

You can see that the `web` and `worker` services are started with new options so they can easily discover the `redis` resource through `REDIS_URL`. You can make a request to the web balancer on port 80:

<pre class="terminal">
<span class="command">curl localhost</span>
Hello World!
</pre>


Now that you've added a link between your app services and resources, you have completed the second phase and can run your app as a set of services running on images.

You now have the foundation you need to [develop your app](/guide/develop/)!

{% include_relative _includes/next.html
  next="Develop your app"
  next_url="/guide/develop/"
%}

