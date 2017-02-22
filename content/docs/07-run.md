---
title: Run
permalink: /guide/run/
---

You just built an image that is designed to run anywhere. The next goals are to:

* Run your app on your development machine with a single command
* Respond to network requests

Let's see what happens when we try to run our app for the first time with `convox start`:

<pre class="terminal">
<span class="command">convox start</span>

build  │ running: docker build -f Dockerfile -t myapp/web myapp
build  │ Sending build context to Docker daemon 315.9 kB
build  │ Step 1 : FROM ubuntu:16.04
build  │  ---> c73a085dc378
build  │ Step 2 : RUN apt-get update &&   apt-get install -y nodejs npm &&   update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
build  │  ---> Using cache
build  │  ---> a0b67b978499
build  │ Step 3 : WORKDIR /app
build  │  ---> Using cache
build  │  ---> 6bc6ad62b443
build  │ Step 4 : COPY package.json /app/package.json
build  │  ---> Using cache
build  │  ---> 99bd045b22aa
build  │ Step 5 : RUN npm install
build  │  ---> Using cache
build  │  ---> 9fa62f8b0211
build  │ Step 6 : COPY . /app
build  │  ---> Using cache
build  │  ---> 7eed4a249d87
build  │ Successfully built 7eed4a249d87
build  │ running: docker tag myapp/web myapp/worker
web    │ running: docker run -i --rm --name myapp-web myapp/web node web.js
worker │ running: docker run -i --rm --name myapp-worker -e GITHUB_API_TOKEN myapp/worker node worker.js
web    │ web running at http://127.0.0.1:8000/
web    │ events.js:141
web    │       throw er; // Unhandled 'error' event
web    │       ^
web    │ 
web    │ Error: Redis connection to 127.0.0.1:6379 failed - connect ECONNREFUSED 127.0.0.1:6379
web    │     at Object.exports._errnoException (util.js:870:11)
web    │     at exports._exceptionWithHostPort (util.js:893:20)
web    │     at TCPConnectWrap.afterConnect [as oncomplete] (net.js:1063:14)
worker │ worker running
worker │ events.js:141
worker │       throw er; // Unhandled 'error' event
worker │       ^
worker │ 
worker │ Error: Redis connection to 127.0.0.1:6379 failed - connect ECONNREFUSED 127.0.0.1:6379
worker │     at Object.exports._errnoException (util.js:870:11)
worker │     at exports._exceptionWithHostPort (util.js:893:20)
worker │     at TCPConnectWrap.afterConnect [as oncomplete] (net.js:1063:14)
</pre>

The image built, and services started, but they errored out immediately. Even if the web service did come up, it's not obvious how you would connect to it.

So your next step is to [define a Balancer](/guide/balancers/).

{% include_relative _includes/next.html
  next="Define a Balancer"
  next_url="/guide/balancers"
%}

