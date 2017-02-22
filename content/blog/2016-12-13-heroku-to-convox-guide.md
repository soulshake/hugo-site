---
author: Noah Zoschke
date: 2016-12-13T00:00:00Z
title: The Heroku to Convox Guide
twitter: nzoschke
url: /2016/12/13/heroku-to-convox-guide/
---

Today I'm pleased to announce [The Heroku to Convox Guide](https://convox.com/guide/heroku/). 

This is a simple, step-by-step guide to migrate [a Twelve-Factor Heroku app](https://12factor.net/) to Convox.

Many parts of the Heroku platform map directly to Convox. For example Convox offers a `convox deploy` command that works just like `git push heroku master`.

Other parts are similar, but represent more significant changes to your apps. For example, Convox leverages Docker to package an app dependencies where Heroku uses buildpacks.

This guide explains the differences of the platforms, and walks you through the steps required to migrate an app.

![Heroku and Convox Similarities](/assets/images/heroku.png)*Heroku and Convox Similarities*

Start by reading the [Introduction](https://convox.com/guide/heroku/). 

If you have any questions or feedback, reach out on the [Convox Slack](https://invite.convox.com) or [GitHub](https://github.com/convox/site/issues/new?title=Heroku+Guide+Feedback).
