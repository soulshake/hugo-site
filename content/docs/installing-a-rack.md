---
title: "Installing a Rack"
order: 100
---

A [Rack](/docs/rack) is installed into your AWS account to manage your infrastructure and provision applications.

<div class="block-callout block-show-callout type-info" markdown="1">
In order to install a Rack you will first need to create temporary AWS credentials. Check out the [IAM policy](/docs/iam-policy) for instructions on setting up the necessary permissions.
</div>

Once launched, installation will take approximately 10 minutes to complete.

## Installing from Console

This is the recommended method for installing a Rack.

* Browse to the [Convox Console](https://console.convox.com/).
* Choose the desired Organization from the dropdown in the top navigation.
* Click **Add a Rack** and then **Install New Rack**.
* Choose a name for your Rack, and select the desired AWS region.
  - See [Supported AWS Regions](/docs/supported-aws-regions) for list of regions currently supported.
* Enter your AWS credentials, or drag the `credentials.csv` file downloaded when you created a Convox IAM user. (If needed, you can create a new access key by clicking on the user in the [AWS Console](https://console.aws.amazon.com/iam/home#/users), from the "Security credentials" tab.)
* Click **Install Convox**.

## Installing from the CLI

Run `convox install --help` to see the available command line options.

<div class="block-callout block-show-callout type-info" markdown="1">
Note: Running `convox install` automatically logs you into the newly created Rack. For more information, see [Login and Authentication](/docs/login-and-authentication/).

</div>

To install a Rack via the CLI, run `convox install` with your desired options:

<pre class="terminal">
<span class="command">convox install</span>
...

Success. Try `convox apps`.
</pre>

### Options

#### Installing in a specific region

You may optionally specify a region other than the default of `us-east-1` by exporting the `AWS_DEFAULT_REGION` or `AWS_REGION` environment variables or using the `--region` flag:

<pre class="terminal">
<span class="command">convox install --region=us-east-1</span>
...

Success. Try `convox apps`.
</pre>


## Installing into an existing VPC

See our [VPC doc](/docs/vpc-configurations#installing-into-an-existing-vpc) for more information.

## What's the difference between installing via Console vs using the CLI?

The CLI installer has some advanced options that aren't available in the web UI yet.

When you install via the CLI, your CLI gets logged into the Rack at the end of a successful installation. That means all commands go straight to the Rack instead of being proxied through Console. After installing a Rack via CLI, you'll need to:

- run `convox login console.convox.com` to log your CLI back into Console
- manually add the Rack to the Console web interface (open the **Add Rack** dropdown and select **Add Existing**)

Then you can activate the Rack by running `convox switch <org>/<rack>`.

For more information, see [Login and Authentication](/docs/login-and-authentication/).

## How do I disconnect a Rack from Convox?

You can unlink a Rack from Convox via the [web console](https://console.convox.com/). Click on the Rack name, then navigate to the `Settings` tab and click `Remove Rack`.

This will not delete any AWS resources. To do that, see [Uninstalling Convox](/docs/uninstalling-convox/).

## How do I uninstall a Rack?

See [Uninstalling Convox](/docs/uninstalling-convox/).
