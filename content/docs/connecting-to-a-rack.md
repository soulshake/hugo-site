---
title: "Connecting to a Rack"
order: 375
---

In some cases you may need to find the Rack's hostname or API key. Those are needed for things like:

* adding a Rack to Console
* authenticating API requests sent directly to the rack (not through Console)
* setting up a [third-party integration](/docs/integrations-overview)

## Rack hostname


You can find your **Rack host** in either of the two following ways:


#### Via the AWS CloudFormation console

Go to the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation), specifying your region (as it appears in `convox rack --rack <name>`) in the upper right.

Then select your Rack stack and navigate to the "Outputs" tab. You'll want the value of the `Dashboard` output, which will have the following format: `<rack-name>-<timestamp>.<aws-region>.elb.amazonaws.com`.

#### Via the AWS CLI

If you've installed the AWS CLI, you can run the following command, replacing `us-east-1` and `legit` with the region and name of your own Rack:

```
aws cloudformation describe-stacks \
    --region us-east-1 \
    --stack-name legit \
    --query 'Stacks[*].Outputs[?OutputKey==`Dashboard`].OutputValue'
```

Your Rack host will be present in the output, which should look something like this:

```
[
    [
        "legit-3122374.us-east-1.elb.amazonaws.com"
    ]
]
```

## Rack API key

Your **Rack API key** is irrecoverable, so if you don't have a record of it from when you first installed your Rack with `convox install -p APIKEY`, or if you installed your Rack from the Console web interface, you'll need to [reset your Rack API key](/docs/api-keyroll#roll-rack-api-key-ne-password).
