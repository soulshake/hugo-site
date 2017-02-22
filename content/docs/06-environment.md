---
title: Environment
permalink: /guide/environment/
phase: build
---

The _environment_ is a set of configuration values for services.

Extracting configuration out of your app code and into the environment enables you to use the same image in development, staging and production.

The environment is defined with the `environment:` section in `docker-compose.yml`:

<pre class="file diff" title="docker-compose.yml">
<span class="diff-u">version: '2'</span>
<span class="diff-u">services:</span>
<span class="diff-u">  web:</span>
<span class="diff-u">    build: .</span>
<span class="diff-u">    command: ["node", "web.js"]</span>
<span class="diff-u">  worker:</span>
<span class="diff-u">    build: .</span>
<span class="diff-u">    command: ["node", "worker.js"]</span>
<span class="diff-a">    environment:</span>
<span class="diff-a">     - GITHUB_API_TOKEN</span>
</pre>

Because the environment holds sensitive secrets, the environment declaration is a whitelist. Here the `web` service will not have access to the `GITHUB_API_TOKEN` variable, but `worker` will.

Now you can declare config specific to development in a local `.env` file:

<pre class="file shell" title=".env">
GITHUB_API_TOKEN=e855b323a2c89d09dee5a2c719041851a71b6606
</pre>

These are sensitive secrets and should be ignored by Docker and Git:

<pre class="file diff" title=".dockerignore">
<span class="diff-u">.git</span>
<span class="diff-a">.env</span>
</pre>

<pre class="file diff" title=".gitignore">
<span class="diff-a">.env</span>
</pre>

The sample Node.js app can reference this configuration via `process.env.GITHUB_API_TOKEN` in your code. This enables you to use a personal GitHub token on your development machine and a company GitHub token in production, without ever having to rebuild the image.

Add the list of environment variables your app uses to `docker-compose.yml`. Create your `.env` file with default development values, and make sure to never include this file in the git repository or image.

Run `convox doctor` to validate the environment:

<pre class="terminal">
<span class="command">convox doctor</span>

### Build: Environment
[<span class="pass">✓</span>] .env found
[<span class="pass">✓</span>] .env valid
[<span class="pass">✓</span>] .env in .gitignore and .dockerignore
[<span class="pass">✓</span>] Service <span class="service">web</span> environment found in .env    
[<span class="pass">✓</span>] Service <span class="service">worker</span> environment found in .env   
</pre>

Now that you've extracted configuration into the environment, you have completed the first phase and built a portable image.

You now have the foundation you need to [run your app](/guide/run/)!

{% include_relative _includes/next.html
  next="Run your app"
  next_url="/guide/run"
%}

