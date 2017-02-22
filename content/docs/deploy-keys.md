---
title: "Deploy Keys"
order: 230
---

Deploy keys are special, limited scope API keys that allow you to run the `build` and `deploy` commands from remote servers for the purposes of continuous integration.

You should give a deploy key to a CI service like [Travis CI](/docs/travis-ci/), [Circle CI](/docs/circle-ci/) or [Datadog](/docs/datadog/) so it can deploy code but not access or modify any other Rack resources. For details, see the **Integrations** section in the list of topics on the left.

![Deploy Keys](/assets/images/docs/rbac/deploy-keys.png){: .screenshot } *List of deploy keys*


## Creating deploy keys

To generate a **deploy key**, log into your account at [console.convox.com](https://console.convox.com), select the appropriate organization, switch to the "Members" tab, and scroll down to the "Deploy Keys" section.

Note: it is not currently possible to create deploy keys for Racks under a `personal` organization. Use the [Rack API key](/docs/api-keys/#rack-api-keys) instead.
