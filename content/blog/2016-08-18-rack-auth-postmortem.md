---
author: Noah Zoschke
date: 2016-08-18T00:00:00Z
title: Rack Authentication Postmortem
twitter: nzoschke
url: /2016/08/18/rack-auth-postmortem/
---

On Wed. August 16th and Thur. August 17th some users could not access their Racks from the CLI or through Console due to authorization problems. While there were no reports of application downtime during this time this was a total control plane outage for some users.

We apologize for the inconvenience to affected users. 

I’d like to explain more what happened and some steps we will be taking to prevent this from happening again.

The biggest change we’d like to implement is the concept of a ‘stable’ and ‘unstable’ release channel. See [GitHub Issue #477](https://github.com/convox/rack/issues/477#issuecomment-240832036) -- **Support Different Endpoints For `convox rack update`** --  to participate in the design of this enhancement and to track progress.

<!--more-->

## Root Cause and Recovery

Recently we set out to make a security improvement to Rack to not display the API key in CloudFormation in plaintext, as reported in [GitHub Issue #425](https://github.com/convox/rack/issues/425).

[Pull Request 969](https://github.com/convox/rack/pull/969) had a patch to use the CloudFormation NoEcho security feature. This was released in version [20160816160115](https://github.com/convox/rack/releases/tag/20160816160115) on Tues. August 16th.

Users that updated to this version and then modified Rack settings from the CLI with `convox rack params set InstanceCount=4` or from the Console UI inadvertently updated the API key to the literal value `****`. This invalidated API keys stored in ~/.convox and/or in Console effectively taking the Rack API offline.

When we understood the problem, we unpublished the version in question, notified non-affected users roll back Racks to the last good release, and worked with affected customers to restore connectivity.

Affected users had to perform a manual CloudFormation procedure to roll back to an earlier release and set a new API key and to work directly with the Convox team to restore Console connectivity.

Late Wed Aug 16th [Pull Request 1088](https://github.com/convox/rack/pull/1088) was released in version [20160818013241](https://github.com/convox/rack/releases/tag/20160816160115) which handles the `convox rack params` path correctly.

We recommend everyone do a standard `convox rack update` to get this latest version.

## Future Improvements

Code refactors to simplify and test mission critical paths like CloudFormation updates are already under way (see [Pull Request 1084](https://github.com/convox/rack/pull/1084)).

We are also looking at ways to improve integration testing and to implement a manual testing checklist around critical paths like API key management.

The clearest feedback from users is to move to a stable and unstable release management system. You can follow [GitHub Issue #477](https://github.com/convox/rack/pull/1084) to track the design and implementation of this.

We will continue to improve how we:

- Use unit testing for fast assurance around how Rack interacts with AWS on every Pull Request
- Use integration testing to actually install, deploy, modify and uninstall Racks on every Release
- Use checklists to manually test paths that are not yet automated
- Offer a way to put staging racks on an `unstable` channel for maximum velocity
- Offer a way to put production racks on a `stable` channel for maximum reliability

If you have more feedback, please reach out on [Slack](http://invite.convox.com/) or [GitHub](https://github.com/convox/rack).