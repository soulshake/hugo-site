---
title: "Deploy"
permalink: /guide/deploy/
---

You just configured your app so that you can develop it locally. The next goal is to get it ready for production. This requires:

* [Provisioning a Rack](/docs/installing-a-rack/)
* Provisioning a production-ready [Postgres](/docs/postgresql/), [MySQL](/docs/mysql/) or [Redis](/docs/redis/) database
* [Releasing your app](/docs/releases/)
* [Scaling your app services](/docs/scaling/)
* [Adding a custom domain](/docs/custom-domains/)
* [Configuring a certificate](/docs/ssl/)

The commands are:

<pre class="terminal">
<span class="command">convox install --region=us-east-1</span>
<span class="command">convox resources create redis</span>
<span class="command">convox apps create myapp</span>
<span class="command">convox deploy</span>
<span class="command">convox env set GITHUB_API_URL=a962c6c31d904c67ae9094ae071de2e3fcfa14f6</span>
<span class="command">convox env set REDIS_URL=redis://atb1alu32d6lfy19.c63i2h.ng.0001.use1.cache.amazonaws.com:6379/0</span>
<span class="command">convox releases promote RUSVPQOHTLF</span>
<span class="command">convox scale web --count=2</span>
<span class="command">convox scale worker --memory=512</span>
<span class="command">convox scale redis --count=-1</span>
<span class="command">convox certs generate foo.example.org</span>
<span class="command">convox ssl update web:443 cert-1234567890</span>
</pre>


{% include_relative _includes/next.html
  next="Install a Rack"
  next_url="/guide/rack"
%}
