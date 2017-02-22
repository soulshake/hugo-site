---
title: One-Off Commands
permalink: /guide/one-off-commands/
phase: develop
---

_One-off commands_ let you execute commands against your app and its tooling. One type of one-off command is `convox start`, which is useful during local development for running tests, migrations, debugging consoles, or other administrative tasks.

This type of command can be executed in a new local container with the syntax `convox start <service> <command>`.

Here's an example:

<pre class="terminal">
<span class="command">convox start web 'node -e "console.log(\"Hello\")"'</span>
</pre>

For more details and other types of commands, see [One-off commands](/docs/one-off-commands/) in the Convox documentation.

Now that you can make code changes and run commands in a development environment, you are ready to [deploy your app](/guide/deploy)!

{% include_relative _includes/next.html
  next="Deploy your app"
  next_url="/guide/deploy/"
%}
