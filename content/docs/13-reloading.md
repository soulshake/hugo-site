---
title: Live Reloading
permalink: /guide/reloading/
phase: develop
---

It's often useful to be able to make changes to your code and see the results immediately, rather than having to restart containers to see changes. This page describes our recommended best practice for doing so.

<div class="block-callout block-show-callout type-info" markdown="1">

Using containers as part of your development workflow can be tricky, especially when the code that you're working on has been baked into an image, which is by definition immutable.

There are a few workarounds for this:

### Bad: Rebuilding your image after making changes, then restarting containers

This method is far too time-consuming in most cases: you shouldn't need to rebuild images every time you want to see the effects of the changes you're making.

### Worse: Getting a shell in a container and modifying the code there

As a general rule, this is a Very Bad Idea. Containers should be considered ephemeral and immutable. Making changes inside a container would require installing development tools (such as a text editor) in the image, causing it to be unnecessarily bloated.

### Better: Bind-mounting app code directory as a volume in the container

One way of getting around this issue is to bind-mount your app code directory as a volume with `docker run` or `docker-compose up`.

This may work in some cases, depending on the app, but most of the time, you still need a way to tell the service to pick up the new changes, such as by recompiling or restarting the web server.

Since many application servers don't notice code changes on the fly until being restarted, a common workaround is to use a drop-in replacement (such as `nodemon` as a replacement for `node`) in development. But we don't want to use those in production for performance and security reasons.

Furthermore, we would only want to mount such volumes in development, not in production.

</div>

## Developing locally with Convox

Convox was built with the development workflow in mind, with respect to the need for maximum parity between development and production environments.

Your app should be structured in a way that allows you to take advantage of Convox's live reloading features during local development, while ensuring proper production behavior when deployed, with minimal changes needed.

Running `convox start` is similar to running `docker-compose build && docker-compose up`, but one major difference is that Convox automatically monitors your code for changes and copies those files to the container immediately.

<div class="block-callout block-show-callout type-warning" markdown="1">
This means you should *not* bind-mount any volumes in your `docker-compose.yml` in order for changes reflected immediately inside the container, as Convox takes care of this for you. (Note: you can disable this behavior with `convox start --no-sync`.)
</div>

## Configuring your app to reload in development

Our recommended best practice is to use a simple, environment-aware "wrapper script" as the `command` or `entrypoint` for a service. When a container for that service is started, this wrapper script should execute the command that is most appropriate for the environment it's in, e.g. production vs. development.

To do so, the wrapper script should look at an environment variable, specified in your `.env` or exported in the environment of the host machine, to determine which command to execute.

We recommend placing this file in a `bin/` directory in the same location as the corresponding `Dockerfile`, and naming it after the corresponding service (in our case, `web`).

For instance: For a simple Node.js app we can execute the `nodemon` reloading tool in development, while executing `node` everywhere else:

<pre class="file js" title="bin/web">
#!/bin/bash

if [ "$NODE_ENV" == "development" ]; then
  $(npm bin)/nodemon web.js "$@"
else
  node web.js "$@"
fi
</pre>

<pre class="file js" title="bin/worker">
#!/bin/bash

if [ "$NODE_ENV" == "development" ]; then
  $(npm bin)/nodemon worker.js "$@"
else
  node worker.js "$@"
fi
</pre>

<pre class="file package.json" title="package.json">
<span class="diff-u">{</span>
<span class="diff-u">  "name": "myapp",</span>
<span class="diff-u">  "version": "1.0.0",</span>
<span class="diff-u">  "main": "index.js",</span>
<span class="diff-u">  "dependencies": {</span>
<span class="diff-a">    "nodemon": "^1.11.0",</span>
<span class="diff-u">    "redis": "^2.6.2"</span>
<span class="diff-u">  },</span>
<span class="diff-u">  "devDependencies": {},</span>
<span class="diff-u">  "scripts": {</span>
<span class="diff-u">    "test": "echo \"Error: no test specified\" && exit 1"</span>
<span class="diff-u">  },</span>
<span class="diff-u">  "keywords": [],</span>
<span class="diff-u">  "author": "",</span>
<span class="diff-u">  "license": "ISC",</span>
<span class="diff-u">  "description": ""</span>
<span class="diff-u">}</span>
</pre>

<pre class="file yaml" title="docker-compose.yml">
<span class="diff-u">version: '2'</span>
<span class="diff-u">services:</span>
<span class="diff-u">  web:</span>
<span class="diff-u">    build: .</span>
<span class="diff-a">    command: ["bin/web"]</span>
<span class="diff-u">    environment:</span>
<span class="diff-u">      - REDIS_URL</span>
<span class="diff-a">      - NODE_ENV=development</span>
<span class="diff-u">    labels:</span>
<span class="diff-u">      - convox.port.443.protocol=https</span>
<span class="diff-u">    links:</span>
<span class="diff-u">      - redis</span>
<span class="diff-u">    ports:</span>
<span class="diff-u">      - 80:8000</span>
<span class="diff-u">      - 443:8000</span>
<span class="diff-u">  worker:</span>
<span class="diff-u">    build: .</span>
<span class="diff-a">    command: ["bin/worker"]</span>
<span class="diff-u">    environment:</span>
<span class="diff-u">      - GITHUB_API_TOKEN</span>
<span class="diff-a">      - NODE_ENV=development</span>
<span class="diff-u">      - REDIS_URL</span>
<span class="diff-u">    links:</span>
<span class="diff-u">      - redis</span>
<span class="diff-u">  redis:</span>
<span class="diff-u">    image: convox/redis</span>
<span class="diff-u">    ports:</span>
<span class="diff-u">     - 6379</span>
</pre>

Now try to run your app via `convox start`. You can see that the `web` and `worker` services are started with a command that indicates reloading is enabled, based on the value of the environment variable you specified (`NODE_ENV` in our case).

<pre class="terminal">
<span class="command">convox start</span>
redis  │ running: docker run -i --rm --name myapp-redis myapp/redis
redis  │ 1:M 15 Oct 21:38:44.893 * The server is now ready to accept connections on port 6379
web    │ running: docker run -i --rm --name myapp-web -e REDIS_URL --add-host redis:172.17.0.2 -e REDIS_SCHEME=redis -e REDIS_HOST=172.17.0.2 -e REDIS_PORT=6379 -e REDIS_PATH=/0 -e REDIS_USERNAME= -e REDIS_PASSWORD=password -e REDIS_URL=redis://:password@172.17.0.2:6379/0 -p 0:8000 myapp/web bin/web
worker │ running: docker run -i --rm --name myapp-worker -e GITHUB_API_TOKEN -e REDIS_URL --add-host redis:172.17.0.2 -e REDIS_SCHEME=redis -e REDIS_HOST=172.17.0.2 -e REDIS_PORT=6379 -e REDIS_PATH=/0 -e REDIS_USERNAME= -e REDIS_PASSWORD=password -e REDIS_URL=redis://:password@172.17.0.2:6379/0 myapp/worker bin/worker
web    │ [nodemon] 1.11.0
web    │ [nodemon] to restart at any time, enter `rs`
web    │ [nodemon] watching: *.*
web    │ [nodemon] starting `node web.js`
web    │ web running at http://127.0.0.1:8000/
worker │ [nodemon] 1.11.0
worker │ [nodemon] to restart at any time, enter `rs`
worker │ [nodemon] watching: *.*
worker │ [nodemon] starting `node worker.js`
</pre>

Make a change to your app code base and you'll see the fast reloading in action!

<pre class="terminal">
convox │ 1 files uploaded
worker │ [nodemon] restarting due to changes...
worker │ [nodemon] starting `node worker.js`
worker │ worker running
convox │ 1 files uploaded
web    │ [nodemon] restarting due to changes...
web    │ [nodemon] starting `node web.js`
web    │ web running at http://127.0.0.1:8000/
</pre>

Now, when you run `convox deploy`, the `command` used will be `node` and not `nodemon`, since the `NODE_ENV` variable won't be set to `DEVELOPMENT` on the production server.

In this way, you can have an ideal local environment for development and a proper deployment environment for production, without needing to make any manual modifications.

Now that we can make changes that quickly reload, let's [run our automated test command](/guide/one-off-commands/).

{% include_relative _includes/next.html
  next="Run test commands"
  next_url="/guide/one-off-commands/"
%}
