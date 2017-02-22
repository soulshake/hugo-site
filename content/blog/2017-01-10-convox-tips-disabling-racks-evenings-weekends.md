---
author: Michael Warkentin
date: 2017-01-10T00:00:00Z
title: 'Convox Tips: Disabling racks on evenings and weekends'
twitter: mwarkentin
url: /2017/01/10/convox-tips-disabling-racks-evenings-weekends/
---

At [Wave](https://www.waveapps.com/) we’re running several [Convox](https://convox.com/) racks: production, staging, and multiple “dev” racks. Our production environment obviously needs to be running constantly, but the other environments are mainly used Monday to Friday, between 9am and 8pm.

One of the reasons we’re migrating to AWS is the improved automation that it provides, and we are leveraging that to turn off our dev and staging racks when they’re not in use — saving roughly 66% on our EC2 bills for those environments.

We played around with a few ways to achieve this, but the simplest ended up being [AWS Auto Scaling Groups Scheduled Actions](http://docs.aws.amazon.com/autoscaling/latest/userguide/schedule_time.html). You can set these up using the AWS console, CLI, or another tool like Terraform.

<!--more-->

## Using the AWS Console

Find your Auto Scaling Group (called `convox-<rack>-Instances-<id>`), and switch to the Scheduled Actions tab:

![](https://cdn-images-1.medium.com/max/2000/1*O-eoQtSzpTpIbkli_y_gTg.png)

Create the Scale Down action by clicking on the Create Scheduled Action button, and fill in the form:

![](https://cdn-images-1.medium.com/max/2000/1*pNh_WBr3rAoq-Ufzzl6I_A.png) *Make sure to adjust the cron schedule to fit your requirements — and you need to convert the times to UTC*

Create the Scale Up action by clicking on the Create Scheduled Action button, and fill in the form:

![](https://cdn-images-1.medium.com/max/1600/1*GCLwAWk_Byl07Nt4RiVA0Q.png) *Note: the default Max for a convox rack is 100, and we only want to scale up Monday — Friday*

When you’re done, you should be have something like this:

![](https://cdn-images-1.medium.com/max/1600/1*4HZs66nLrTJFi7gyBJuncg.png)

## Using the AWS CLI

If you want to automate things a bit more, you can configure the scheduled actions using the AWS CLI. Create the following files:

**down.json**

```
{
    "AutoScalingGroupName": "convox-<rackname>-Instances-<id>",
    "ScheduledActionName": "ScaleDown",
    "Recurrence": "0 0 * * *",
    "MinSize": 0,
    "MaxSize": 0,
    "DesiredCapacity": 0
}
```

**up.json**

```
{
    "AutoScalingGroupName": "convox-<rackname>-Instances-<id>",
    "ScheduledActionName": "ScaleUp",
    "Recurrence": "0 12 * * MON-FRI",
    "MinSize": 0,
    "MaxSize": 0,
    "DesiredCapacity": 0
}
```

And then run the following:

```
$ aws autoscaling put-scheduled-update-group-action --cli-input-json file://down.json
$ aws autoscaling put-scheduled-update-group-action --cli-input-json file://up.json
```

## Using Terraform

We are using Terraform to manage things like this which are outside of Convox’ scope (another post coming soon!), so we created a simple module we can use for our dev environments to set up these scheduled actions for us:

**modules/dev_scaling_schedule/main.tf**

```
variable "asg_name" {}

variable "scale_up_capacity" {  
  type    = "string"  
  default = "4"
}

variable "scale_down_recurrence" {  
  type    = "string"  
  default = "45 0,6 * * *" # UTC
}

variable "scale_up_recurrence" {  
  type    = "string"  
  default = "15 12 * * MON-FRI" # UTC
}

variable "min_size" {  
  type    = "string"  
  default = "1"
}

variable "max_size" {  
  type    = "string"  
  default = "100"
}

resource "aws_autoscaling_schedule" "scale_down" {  
  autoscaling_group_name = "${var.asg_name}"  
  scheduled_action_name  = "ScaleDown"  
  recurrence             = "${var.scale_down_recurrence}"       
  desired_capacity       = 0
}

resource "aws_autoscaling_schedule" "scale_up" {    
  autoscaling_group_name = "${var.asg_name}"  
  scheduled_action_name  = "ScaleUp"  
  recurrence             = "${var.scale_up_recurrence}"  
  desired_capacity       = "${var.scale_up_capacity}"  
  min_size               = "${var.min_size}"  
  max_size               = "${var.max_size}"
}
```

## Final Notes

* Sometimes, a dev needs to do some work late in the evening, or on a weekend. We’ve created Jenkins jobs to allow our devs to turn the environment on/off as needed. We also added a second scale down time late at night in case the developer forgot to turn the rack back off.
* It usually takes between 5–10 minutes for a rack to spin up and start all of the app processes.
* We’re saving over $200/m by scaling our dev racks down during off hours. This will only grow as we increase instance sizes, counts and number of developer racks.

## About The Author

Michael is an Operations Engineer at [Wave](https://www.waveapps.com/). We provide invoicing, credit card payments, accounting, and payroll for small businesses. If you're interested in joining the team, check out our [careers page](https://www.waveapps.com/about-us/jobs/) to find out why it's a great place to work and get in touch!
