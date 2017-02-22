---
author: Sandeep Chivukula
date: 2016-10-19T00:00:00Z
title: Botmetrics Enterprise Deployment on AWS with Convox
twitter: _sandeep
url: /2016/10/19/botmetrics-enterprise-grade-deployment-on-aws/
---

[Botmetrics](https://www.getbotmetrics.com) is an [open source package](https://github.com/botmetrics/botmetrics) and [a hosted service](http://www.getbotmetrics.com) for measuring and growing Facebook Messenger, Kik, Slack and in-app messaging bots. 

Analytics for web and mobile rely on events to deliver insights. For chat bots, on the other hand, insights comes from analyzing the content of conversations. Botmetrics accomplishes this with several services—collectors, workers, and a web app for interfacing with the user. These need to be setup separately and configured to work in concert.

![Botmetrics Architecture Diagram](https://medium2.global.ssl.fastly.net/max/2000/1*GgZPs13LmUueafcf8NI4YQ.png)*Botmetrics Architecture Diagram*

<!--more-->

Convox makes it almost trivial to bring up this mix of Go and Ruby services in a coordinated and scalable way. We're going to assume that you already have a [Rack](https://github.com/convox/rack) set up and the Convox CLI installed. If not, follow [The Convox Guide](https://convox.com/guide/) to set up your laptop and cloud environment.

## Setting up the Botmetrics App

Clone the [Botmetrics repo](http://www.github.com/botmetrics/botmetrics) and in your `botmetrics` directory issue the following commands to set up the app:

* `convox apps create` to create an application called `botmetrics`
* `convox apps info` to check if the app has been created

![Checking on App Status](https://medium2.global.ssl.fastly.net/max/3596/1*yuyld8ZDdggOYM_OUPMhuQ.png)*Checking on App Status*

## Adding Databases

We will use the RDS Postgres and ElastiCache Redis services from Amazon which allow us to scale as needed with minimal effort.

Provisioning a Postgres database and Redis key store is easy with Convox:

* `convox services create postgres`
* `convox services create redis`
* `convox services` to see the names and provisioning status of the services

![Getting Service Names](https://medium2.global.ssl.fastly.net/max/3600/1*HUtYBgneEDNMNhK_Rbo9CA.png)*Getting Service Names*

## Deploying to Production and Initial Setup

Now it's time to deploy the app. Kick it off with `convox deploy`. (Time to go surf reddit.)

## Setting up the Environment

Next, we need to set the environment variables for Redis and Postgres so that web and worker services can access the databases we just provisioned.

For each service instance (Redis and Postgres) you can get the URL with:

* `convox services info <service_instance_name>`

Then set the environment variables REDIS_URL for Redis and DATABASE_URL for Postgres with:

* `convox env set <VARIABLE_NAME> <URL>`

![Setting the REDIS_URL and DATABASE_URL Environment Variables](https://medium2.global.ssl.fastly.net/max/3600/1*9vu54wEe7jqBnGMs1qbuzw.png)*Setting the REDIS_URL and DATABASE_URL Environment Variables*

You then need to set a few other environment variables that are required for Botmetrics to boot up in production mode:

* `convox env set RAILS_ENV=production SECRET_KEY_BASE=$(openssl rand -hex 32) JSON_WEB_TOKEN_SECRET=$(openssl rand -hex 32)`

Once you're done, promote the release ID that is printed:

* `convox releases promote <RELEASE-ID-AFTER-SETTING-PROD-VARIABLES>`

Run `convox apps info` to get the status of your app and once it is `running`, you can proceed to migrate your database.

## Migrating your database

Once the app is deployed set up your database for the first time with:

* `convox run web rake db:structure:load db:seed`

Get the public URL for your app with:

* `convox apps info`

![Getting the App Hostname](https://medium2.global.ssl.fastly.net/max/3600/1*757jJ63VvdtU0VT6wcBGZg.png)*Getting the App Hostname*

Browse to the URL and start collecting data from your bots!

![Botmetrics Homepage!](https://medium2.global.ssl.fastly.net/max/2640/1*D19tEMuLz_d5nzuKi6t5sg.png)*Botmetrics Homepage!*

## Updating your Botmetrics App

When future updates of Botmetrics land, you can `git pull` the latest version from GitHub and run `convox deploy` to deploy the changes to your private infrastructure.

## Stay Connected

If you want to talk bots, analytics or have questions we're available [@getbotmetrics on Twitter](https://www.twitter.com/getbotmetrics) or by email: [hello@getbotmetrics.com](mailto:hello@getbotmetrics.com).
