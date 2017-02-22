---
author: Luke Roberts
date: 2016-04-21T00:00:00Z
title: Scheduled Tasks
twitter: awsmsrc
url: /2016/04/21/scheduled-tasks/
---

Over the past week the team (and in particular my friend [Matt](https://twitter.com/mattmanning)) has been working on a feature I'm excited to share with you. Convox now natively supports Scheduled tasks. This allows you to specify units of work, ran at any interval you desire with out writing any extra code.

<!--more-->

## A practical example

Let's say you are working on an application that collects analytics on behalf of your users about their customers behaviour, and you want to send a daily update summary to each user. Let's assume you already have a well tested application written in the language of your choice successfully running on Convox. If that was the case you would probably have a docker-compose.yml file containing the following process definition

```
web:
  build: .
  volumes:
    - .:/src
  ports:
    - "3000:3000"
```

To actually collate the data and send the email, you would write a script or program in the language of your choice, in this example we will use a bash script at `bin/daily_update`, but this could easily be Rake or even an installed binary. 

So how would you tell Convox how and, more importantly when to run your task? Well I'll tell you; with **labels**.

As you can see in the following example we simply and declaratively add a label with a crontab entry to our applications docker-compose.yml:

```
web:
  build: .
  volumes:
    - .:/src
  ports:
    - "3000:3000"
  labels:
    - convox.cron.daily_update=0 8 * * ? bin/daily_update
```

To have the task to run at different intervals you could manipulate the crontab entry to match any of the example expressions:

<table>
  <tr>
    <th>Expression</th>
    <th>Meaning</th>
  </tr>
  <tr>
    <td><code>* * * * ?</code></td>
    <td>Run every minute</td>
  </tr>
  <tr>
    <td><code>*/10 * * * ?</code></td>
    <td>Run every 10 minutes</td>
  </tr>
  <tr>
    <td><code>0 * * * ?</code></td>
    <td>Run every hour</td>
  </tr>
  <tr>
    <td><code>30 6 * * ?</code></td>
    <td>Run at 6:30am UTC every day</td>
  </tr>
  <tr>
    <td><code>30 18 ? * MON-FRI</code></td>
    <td>Run at 6:30pm UTC every weekday</td>
  </tr>
  <tr>
    <td><code>0 12 1 * ?</code></td>
    <td>Run at noon on the first day of every month</td>
  </tr>
</table>

## How does it work?

We've taken a single line of config and configured a powerful production ready task runner without the need to install, configure or maintain  any 3rd party dependencies or services, but how?

The current implementation converts the crontab entry to a [scheduled Lambda function](http://docs.aws.amazon.com/lambda/latest/dg/with-scheduled-events.html). This function basically uses Convox APIs to run the command specified in a container in your Rack. To read more you can check out the [Scheduled Tasks documentation](/docs/scheduled-tasks/). 

We'd love to hear how you might use this feature and feedback, as always, is very welcome.
