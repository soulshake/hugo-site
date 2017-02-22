---
title: "Updating Old Apps"
order: 900
---

A small number of old Convox apps — those created with Rack releases older than `20160223211445` — have a different load balancer configuration than what is used in current apps. Recent changes to Convox Rack break backwards compatibility with these apps, causing problems if they are deployed. This guide explains how to identify old apps and deploy new ones to replace them.

## How to recognize an old app

Use the `convox apps info` command to inspect the endpoint configuration of your app. If you have an old app, the configuration will look like this:

```
$ convox apps info -a oldapp
Name       oldapp
Status     running
Release    REWZSEJGF
Processes  web
Endpoints  oldapp-1027791460.us-east-1.elb.amazonaws.com:80 (web)
```

Note that the leftmost segment of the domain has the structure `<app name>-<random number>`. There is no process name. If any of your endpoints have this format, then you have an old app that needs to be updated using the process below.

By contrast, a new app looks like this:

```
$ convox apps info -a newapp
Name       newapp
Status     running
Release    RHMDDYNTMLS
Processes  web database
Endpoints  newapp-web-5YMD4CB-7924824.us-east-1.elb.amazonaws.com:80 (web)
           internal-newapp-database-3LOPPMR-i-390257104.us-east-1.elb.amazonaws.com:5432 (database)
```

Note that the leftmost segment of the domain has the format `<app name>-<process name>-<random string>-<random-string>`. If all of your endpoints are of this format or the shown internal format, then your app does not need to be updated.

## How to update

The best way to avoid problems is to deploy to a new Convox app. That can be achieved with the following steps.

#### Create a new app

```
$ convox apps create newapp
```

#### Configure environment

Use the command below to copy environment variables from the old app to the new app.

```
$ convox env -a oldapp | convox env set -a newapp
```

If you get errors from this command you can still fetch the enviroment from the ECS TaskDefinition. From the ECS web page, click "Task Definitions". Click the TaskDefinition that matches your app, then click the latest version. On the next page, expand the process name and view the "Environment Variables" section.

#### Deploy

```
$ convox deploy -a newapp
```

#### Scale

Use the [convox scale command](/docs/scaling) to scale the newapp processes to the desired levels.

#### SSL and DNS

If necessary, [configure SSL](/docs/ssl/) on the new app.

Update any DNS records to point to the new app. You can find the new endpoint addresses with:

```
$ convox apps info -a newapp
```

#### Update syslog link (if applicable)

If your app is linked to a [syslog resource](/docs/syslog) link the new app:

```
$ convox resources link resource-name -a newapp
```

Once you have the new app in production, unlink from the old app:

```
$ convox resources unlink resource-name -a oldapp
```

Deleting the old app will also remove the link.
