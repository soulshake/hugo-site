---
author: Matt Manning
date: 2015-11-20T00:00:00Z
title: 'Grid: Devops Services for Engineering Teams'
twitter: mattmanning
url: /2015/11/20/introducing-grid/
---

We are proud to announce the latest addition to the Convox platform: [Grid](https://grid.convox.com).

In August we launched [Convox Rack](http://convox.com/docs/what-is-a-rack/) which installs a rock-solid, private PaaS into your own AWS account minutes. The response to Rack has been thrilling. People all over the world are using it to deploy and scale their applications. Rack is a powerful tool for sure, but a great platform is about more than just managing apps. It's also about managing teams and workflows. Enter Grid.

<!--more-->

Grid is the hub for your modern DevOps organization. It provides intuitive, web-based tools to install Racks, seamlessly switch between Racks via the CLI, control developer access, and integrate with 3rd-party services to leverage powerful workflows.

While we have a ton of exciting features in the pipeline for Grid, we're proud to launch today with 3 powerful tools that we think you'll love: Rack sharing, GitHub integration, and Slack integration.

## Rack Sharing

As engineers the vast majority of us work on teams. Sharing (and limiting) access to resources among an engineering team is critical. Security best practices demand that each engineer has unique, resettable credentials for any critical system.

Grid enables sharing of one or many Racks by acting as a control point for CLI commands. Now, instead of authenticating with a Rack directly using a shared password, your engineers can authenticate with Grid using an API key. Each engineer gets a unique, resettable key. CLI commands are transparently proxied through Grid to the desired Rack, allowing you keep the Rack password secret.

Inviting new engineers to collaborate on a rack is a breeze using the Grid web interface. Revoking their access is a simple click of a button.

Rack sharing is a free feature of Grid. We have many plans for enhancements such as audit logging and role-based access controls that will be added to our paid plans in the near future.

## GitHub integration

Continuous integration / continuous delivery workflows are very popular, and we at Convox believe that you should never do something manually when it can be automated. Grid works with GitHub to make these kinds of workflows easy to set up.

You can [sign up to Grid](https://grid.convox.com/grid/signup) using your Github account or [link your existing Grid account to GitHub](https://grid.convox.com/grid/user/integrations). Once you're linked you can easily add GitHub webhooks to any of your Convox apps.

Webhooks can trigger automatic builds and deployments to your Convox app when you push Code to master on GitHub. We're working on more triggers -- such as pushes to branches and commit status changes -- that will enable even more powerful CI workflows, so stay tuned.

You can configure webhooks from public GitHub repos for free. Private repos are available via the Basic paid plan.

## Slack integration

Chat rooms are the command centers for DevOps teams, and perhaps no chat service has more buzz these days than Slack.

Grid implements the
[Add to Slack button](http://slackhq.com/post/127498327415/addtoslack). Once you add your Rack to a Slack channel you'll start receiving notifications of all the critical events on that Rack including:

  - Rack version updates
  - App create and delete
  - Releases
  - Release promotions
  - Service create and delete

Slack notifications are free. We're working on Slack commands that will let you control your Rack from chat for a true ChatOps experience.

## Level up today

With Grid and Rack you get DevOps best practices in minutes:

- Automated infrastructure change management
- Isolated development, staging and production environments
- Automated `git push` test and deploy workflows
- API / CLI / ChatOps for application debugging and scaling

The [Convox community](https://invite.convox.com) is sailing along with elegant workflows around rock-solid infrastructure. Take a look at [Grid](https://grid.convox.com/), and consider how it will level up your engineering team.

> Discuss on [Hacker News](https://news.ycombinator.com/item?id=10603550)
