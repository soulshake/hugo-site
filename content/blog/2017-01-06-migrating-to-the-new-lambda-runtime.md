---
author: Matt Manning
date: 2017-01-06T00:00:00Z
title: Migrating to the New Lambda Runtime
twitter: mattmanning
url: /2017/01/06/migrating-to-the-new-lambda-runtime/
---

**tl;dr:** If you’re having trouble creating apps or resources, upgrade your CLI and Rack to the latest versions. **Please note that you will not be able to roll back to a previous Rack release older than `20170106053301` after updating.**

## The Details

On the evening of January 5, AWS turned off the ability to create Lambda functions that use the nodejs v0.10 runtime. All future functions must be created on the nodejs 4.3 runtime. More details [here](http://docs.aws.amazon.com/lambda/latest/dg/nodejs-prog-model-using-old-runtime.html).

The CloudFormation template for Convox creates Lambda functions, so the AWS change immediately blocked the ability to install Racks. It also blocked the creation of new apps on existing Racks.

Convox uses Lambda in several ways, including as glue for CloudFormation [Custom Resources](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-custom-resources.html) to provision and manage some AWS resources. Unfortunately, it is not possible to replace these Lambda functions into the new runtime, because of restrictions within CloudFormation.

## Our Solution

Going forward, beginning with Rack version `20170106053301`, all new Lambda functions use the nodejs 4.3 runtime. Where possible, older Lambda functions will be replaced during Rack updates and app deployments.

We introduced the Lambda runtime as a CloudFormation parameter (CustomTopicRuntime), so we can retain the nodejs 0.10 runtime on the Lambda functions we can't replace.

Please note that once a Rack has been updated to version `20170106053301` or later it will not be possible to roll it back to versions before 20170106053301. This would require the creation of Lambda functions in the nodejs 0.10 runtime, which is no longer allowed by AWS.

We are working on a plan to get all Convox-managed Lambda functions onto the new runtime. Those changes will be rolled out in future Rack versions.
