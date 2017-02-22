---
title: "SSH Keyroll"
---

Keyroll generates and replaces the EC2 keypair used for SSH. Under the hood, this replaces an entire cluster with new instances and new SSH keys.

Note that `convox instances ssh` won't work at all until you do a successful keyroll.


### Roll Rack SSH key 
 
`convox instances keyroll` creates (or regenerates, if one exists already) the SSH key behind `convox instances ssh`. 

This sets up a keypair between the Rack API and the EC2 instances for SSH access. You can then use the `convox instances ssh <instanceID>` command to get SSH access to the instances.


## Under the hood

Keyroll triggers a CloudFormation update that performs a rolling replacement of all of the Rack's instances.

## SSH Keyroll FAQ

### Why is the Rack unavailable during an SSH instance keyroll?

If a service has fewer than 3 containers, downtime can happen when you run `convox instances keyroll` (indeed, any time there is a full instance replacement).

This downtime can be avoided by running at least 3 containers of any critical service. If you have 2 containers you'll *sometimes* get short downtime. If you have only 1 container, you'll be guaranteed some downtime.

This is an unfortunate side effect of how autoscale groups terminate instances based on the desired count in one shot.

We've talked about various solutions with AWS, who we hope will make ECS instance replacement more graceful. The problem is addressed in [this GitHub issue](https://github.com/aws/amazon-ecs-agent/issues/130) (upvotes here would help!).

### Can I provide my own SSH keys to be installed on the instances?

No, for a couple of reasons.

The instances on which a Rack is running are terminated frequently and replaced, so instead of ssh-ing directly to the instances, Convox supplies a proxied connection via `convox instances ssh`.

Furthermore, we consider it a best practice to consider your infrastructure ephemeral and immutable. Therefore, we discourage relying on direct SSH access to your instances because in a well-designed system, it shouldn't be necessary.
