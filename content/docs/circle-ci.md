---
title: "CircleCI"
order: 200
---

You can streamline your workflow by integrating Convox and CircleCI. At a high level, you'll be using familiar CLI commands like `convox build` and `convox deploy`, only from your CircleCI build servers.

## Modifying circle.yml

The [deployment section](https://circleci.com/docs/configuration/#deployment) of `circle.yml` lets you specify commands to run after a successful build. In the example below, a successful build of the `master` branch would trigger a deployment of `example-app` to the `org/staging` Rack.

    staging:
      branch: master
      commands:
        - convox deploy --app example-app --rack org/staging

## Authentication

You'll also need to enable the CircleCI build server to authenticate with your Rack before it can run commands like `convox build` or `convox deploy`. When using the CLI from your development machine, you'd typically `convox login` to do so, but when using CircleCI, you'll want to set `CONVOX_HOST` and `CONVOX_PASSWORD` instead. To set environment variables in CircleCI, follow their instructions for [keeping your environment variable secrets out of version control](https://circleci.com/docs/environment-variables/#setting-environment-variables-for-all-commands-without-adding-them-to-git).

### Authenticating with Console deploy keys

If you use [Console](https://console.convox.com/) to manage access to your Racks, you'll need to set the following environment variables in CircleCI:

    CONVOX_HOST=console.convox.com
    CONVOX_PASSWORD=<deploy key>

To generate a **deploy key**, log into your account at [console.convox.com](https://console.convox.com), select the appropriate organization, switch to the "Members" tab, and scroll down to the "Deploy Keys" section.


### Authenticating directly with a Rack

If you do not use [Console](https://console.convox.com/), you can grant CircleCI direct access to your Rack by setting the following environment variables in CircleCI:

    CONVOX_HOST=<Rack host>
    CONVOX_PASSWORD=<Rack password>

You can find your **Rack host** by visiting the CloudFormation console, selecting your Rack stack, and navigating to the "Outputs" tab. You'll want the value of the "Dashboard" output, which will have the following format: `<rack-name>-<timestamp>.<aws-region>.elb.amazonaws.com`.

Your **Rack API key** is irrecoverable, so if you don't have a record of it from when you first installed your Rack with `convox install -p APIKEY`, or if you installed your Rack from the Console web interface, you'll need to [reset your Rack API key](/docs/api-keyroll#roll-rack-api-key-ne-password).
