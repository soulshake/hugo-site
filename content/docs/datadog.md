---
title: "Datadog"
order: 300
---


You can add operational visibility to your Convox environments with Datadog.

## Sign up for Datadog

If you don’t have an account already, [sign up for Datadog](https://app.datadoghq.com/signup). You’ll need an API key that lets you send data from Convox to the Datadog service.

## Deploy the Datadog Agent

You can deploying the datadog agent as a Convox app with a very simple docker-compose.yml manifest:

```bash
# check out the repo
$ git clone https://github.com/convox-examples/dd-agent.git
$ cd dd-agent

# create the app and secrets
$ convox apps create
$ convox env set API_KEY=<your api key>
$ convox deploy
$ convox scale agent --count=3 --cpu=10 --memory=128
```

Use a `count` that matches the `InstanceCount` parameter of your Rack.

## Auto Scaling

If your Rack is configured to Autoscale, you'll need to dynamically scale the Datadog agent count to match the Rack instance count.

See the [Listening for ECS CloudWatch Events Tutorial](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_cwet.html) for guidance.
