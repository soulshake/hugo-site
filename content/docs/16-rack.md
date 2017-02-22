---
title: Rack
permalink: /guide/rack/
phase: deploy
---

Deploying an application on AWS requires quite a few moving parts. _Rack_ is our attempt to abstract these components into a cohesive, reliable whole that works for most applications.

You can deploy one or more applications to a Rack.

## What is a Rack, exactly?

A Rack is secure cloud environment. It is a collection of a VPC, VM and Container cloud services that are configured to run your app images and services.

Convox installs the resources composing a Rack into your AWS account, then helps you manage it via the `convox` CLI and web console.

You don't have to worry about the underlying infrastructure, but if you do look [under the hood](https://convox.com/docs/rack/), you'll find a simple open-source system that packages up the best practices of cloud infrastructure management.

Since all Rack components are installed in your own AWS account, you can always add extras or tweak things if needed.

## Installing a Rack

Though there are other ways, we recommend installing Racks from the [web console](https://console.convox.com/).

<div class="block-callout block-show-callout type-info" markdown="1">
### AWS credentials

Provisioning a Rack requires AWS credentials with sufficient IAM permissions. See [this page](https://convox.com/docs/iam-policy/) for instructions.
</div>

For our example app, we'll enter the following in the Rack install interface:

| **Name**: | `example` |
| **Organization**: | `personal` |
| **Private**: | [unchecked] |
| **AWS Region**: | `us-east-1` |
| **AWS Access Key ID**: | `YOUR_ACCESS_KEY_ID` |
| **AWS Secret Access Key**: | `YOUR_SECRET_ACCESS_KEY` |

This will take approximately 10 minutes while AWS configures all the cloud services in your Rack.

You can view the installer logs by clicking `View logs` from the web console:

```
Installing example
***** TASK 1/1 [rack_install] for job c99dcc4d-4cb1-4302-8f13-817bebbd1bc7


     ___    ___     ___   __  __    ___   __  _
    / ___\ / __ \ /  _  \/\ \/\ \  / __ \/\ \/ \
   /\ \__//\ \_\ \/\ \/\ \ \ \_/ |/\ \_\ \/>  </
   \ \____\ \____/\ \_\ \_\ \___/ \ \____//\_/\_\
    \/____/\/___/  \/_/\/_/\/__/   \/___/ \//\/_/


Installing Convox (20161102160040)...
Created ECS Cluster: example-Cluster-8BMH9ZW0JY30
Created CloudWatch Log Group: example-LogGroup-8IHA9D2VEGZH
Created VPC Internet Gateway: igw-d7db6eb0
Created Lambda Function: example-LogSubscriptionFilterFunction-1R30H98SX7OXC
Created VPC: vpc-c4e80aa2
Created Lambda Function: example-InstancesLifecycleHandler-1LRE58OETACI1
Created S3 Bucket: example-settings-81urxdl13l6
Created S3 Bucket: example-registrybucket-in54buv1gev7
Created Lambda Function: example-CustomTopic-8190G32V47R5
Created DynamoDB Table: example-releases
Created EFS Filesystem: fs-503deb19
Created DynamoDB Table: example-builds
Created IAM User: example-RegistryUser-1VZ19G9WEFAXR
Created IAM User: example-KernelUser-1JEGVZCV5TZCK
Created KMS Key: EncryptionKey
Created Security Group: sg-4914b534
Created Security Group: sg-5e14b523
Created Access Key: AKIAIMR5WAZUZGC2U3GQ
Created Access Key: AKIAIZNCYVUM64JH6ERQ
Created Routing Table: rtb-0c30666a
Created VPC Subnet: subnet-346bf37d
Created VPC Subnet: subnet-4b07ae66
Created VPC Subnet: subnet-3a58f561
Created Elastic Load Balancer: example
Created ECS TaskDefinition: RackWebTasks
Created ECS TaskDefinition: RackMonitorTasks
Created ECS TaskDefinition: RackBuildTasks
```

And you can view the status of the installation by running the `convox racks` command from a terminal:

```
$ convox racks
RACK               STATUS
personal/python    running
personal/example   installing
personal/dev       running
```

For more advanced options, including how to install a Rack via CLI, see [installing a Rack](https://convox.com/docs/installing-a-rack/) in the Convox docs.

## How do I start using a Rack?

Once your Rack has been installed and provisioned, navigate on the command line to the directory that contains your application.

Once `convox racks` shows that your new Rack is `running`, type `convox switch <org>/<rack>` to begin using it:

```
$ convox switch personal/example
Switched to personal/example
```

Run `convox rack` to view more information about the Rack:

```
$ convox rack
Name     example
Status   running
Version  20161102160040
Region   us-east-1
Count    3
Type     t2.small
```

## How do I update a Rack?

If needed, you can update the underlying Convox internals running your Rack by running `convox rack update`.


```
$ convox rack update
Updating to 20161102160040... ERROR: no system updates are to be performed
```

## Rack in action with the example app

Now that we've installed a rack, let's get ready to see it in action.

### `convox doctor`

At the time of this writing, no Rack-related checks have been added to `convox doctor` yet, so there's nothing to see here for now. Check back soon!

### `convox apps`

Since we haven't created any apps in this tutorial yet, running `convox apps` should show an empty list:

```
$ convox apps
APP  STATUS
```

So next, let's [create our first app](/guide/app/).

{% include_relative _includes/next.html
  next="Create an app"
  next_url="/guide/app/"
%}
