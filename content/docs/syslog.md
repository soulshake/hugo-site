---
title: "Syslog"
---

## Resource Creation

You can forward your logs to syslog using the `convox resources create` command:

    $ convox resources create syslog --url tcp+tls://logs1.papertrailapp.com:12345
    Creating syslog-3785 (syslog)... CREATING

This will create a syslog forwarder. Creation will take a few moments. To check the status use `convox resources info`.

### Additional Options

<table>
  <tr><th>Option</th><th>Description</th></tr>
  <tr><td><code>--name=<b><i>&lt;name&gt;</i></b></code></td><td>The name of the resource to create</td></tr>
  <tr><td><code>--private</code></td><td>Create in private subnets</td></tr>
</table>

## Resource Information

To see relevant info about the forwarder, use the `convox resources info` command:

    $ convox resources info syslog-3785
    Name    syslog-3785
    Status  running
    Exports
      URL: tcp+tls://logs1.papertrailapp.com:12345

## Resource Linking

To forward logs from an application to a syslog forwarder use `convox resources link`:

    $ convox resources link syslog-3785 --app example-app
    Linked syslog-3786 to example-app

## Resource Deletion

To delete the syslog forwarder, use the `convox resources delete` command:

    $ convox resources delete syslog-3785
    Deleting syslog-3785... DELETING

## VPC Access

In most cases you will be shipping logs via the syslog resource to an external drain like Papertrail or Logentries, for example. However, in some cases you might want to ship the logs back to a syslog drain running in your Rack. For this to work, you'll need to first switch your rack to [private networking mode](/docs/private-networking/) before creating the syslog resource.

Any pre-existing syslog resources already shipping logs to external drains will continue to work if you switch your Rack to private mode.

WARNING: If you want to switch your Rack back to public networking mode after creating syslog resources in private mode, you will need to do some manual cleanup. This is an unfortunate, known limitation of AWS Lambda.

First, delete the syslog resource(s) created in private mode: `convox resources delete syslog-1234`

Next, log into the AWS VPC console. You will need to manually remove an Elastic Network Interface (ENI). The ENI ID varies, but its description in the AWS console will begin with `AWS Lambda VPC ENI`. Once the ENI is manually detached and deleted, it is safe to disable private networking. If you need assistance with this process, please open a support ticket at [https://console.convox.com](https://console.convox.com).
