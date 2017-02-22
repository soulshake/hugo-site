---
title: Releases and rollbacks
permalink: /guide/releases/
phase: deploy
---

A _release_ is a specific version of an app corresponding to its state at the time of a given deployment.

## Releases

Each time you deploy with `convox deploy` (or update the app's env, as we'll see later), a new release is created.

View your app's releases by running `convox releases`:

```
$ convox releases
ID           CREATED        BUILD        STATUS
RZYWJKKRDLI  5 minutes ago  BXFGHCQLZGQ  active
```

Let's make a minor modification to [our app's code](https://github.com/convox-examples/convox-guide/) in `web.js` to illustrate how releases work.


<pre class="file web.js" title="web.js">
<span class="diff-u">var server = http.createServer(function(request, response) {</span>
<span class="diff-u">  console.log(request.method, request.url)</span>
<span class="diff-u"></span>
<span class="diff-u">  client.rpush("queue", JSON.stringify(request.headers));</span>
<span class="diff-u"></span>
<span class="diff-u">  response.writeHead(200, {</span>
<span class="diff-u">    "Content-Type": "text/plain"</span>
<span class="diff-u">  });</span>
<span class="diff-r">  response.end("Hello World!\n");</span>
<span class="diff-a">  response.end("Greetings, Earthlings!\n");</span>
<span class="diff-u">});</span>
</pre>

Now run `convox deploy` again.

```
$ convox deploy
Deploying convox-guide
Creating tarball... OK
Uploading: 1.68 KB / 1.50 KB [===========================] 111.49 % 0s
Starting build... OK
Authenticating 922560784203.dkr.ecr.us-east-1.amazonaws.com: Login Succeeded

running: docker build -f /tmp/863277643/Dockerfile -t convox-guide/web /tmp/863277643
Sending build context to Docker daemon  12.8 kB
Step 1 : FROM ubuntu:16.04
16.04: Pulling from library/ubuntu
6bbedd9b76a4: Already exists
fc19d60a83f1: Already exists
[snip]
8ba4b4ea187c: Layer already exists
c854e44a1a5a: Layer already exists
worker.BCSWGHMOTTQ: digest: sha256:3c7215a1584596d761cdd6be7f445688fa6e5844f3da5d5b58a4d84b48874a29 size: 7864
Promoting RZBZBKXSPYV... UPDATING
```

We can see our new release by running `convox releases` again:

```
$ convox releases
ID           CREATED         BUILD        STATUS
RZBZBKXSPYV  37 seconds ago  BCSWGHMOTTQ  active
RZYWJKKRDLI  15 minutes ago  BXFGHCQLZGQ
```

And we can see our app is `updating`:

```
$ convox apps
APP           STATUS
convox-guide  updating
```

The app will remain in `updating` for a few minutes while some things happen under the hood (like waiting for the AWS ECS service to stabilize).

Once the app is `running` again, refresh your web browser to see your change has taken effect:

```
$ curl convox-guide-web-z5yq7fa-1775143282.us-east-1.elb.amazonaws.com
Greetings, Earthlings!
```


## Rolling back to a previous release

If a deployment causes unexpected results, you can easily roll back to a previous release.

To do so, get the desired release ID from your list of releases:

```
$ convox releases
ID           CREATED         BUILD        STATUS
RZBZBKXSPYV  5 minutes ago   BCSWGHMOTTQ  active
RZYWJKKRDLI  20 minutes ago  BXFGHCQLZGQ
```

Then run `convox releases promote <release id>`:

```
$ convox releases promote RZYWJKKRDLI
Promoting RZYWJKKRDLI... UPDATING
```

This will take a few minutes. Once `convox apps` changes from `updating` to `running`, you can see the release has been reverted:

```
$ curl convox-guide-web-z5yq7fa-1775143282.us-east-1.elb.amazonaws.com
Hello World!
```

## Further reading

* [Releases](/docs/releases/) in the Convox docs
* [Rolling back](/docs/rolling-back/) in the Convox docs

{% include_relative _includes/next.html
  next="Configure resources"
  next_url="/guide/resources/"
%}
