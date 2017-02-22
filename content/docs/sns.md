---
title: "SNS"
---

## Resource Creation

You can create SNS topics using the `convox resources create` command:

    $ convox resources create sns
    Creating sns-3331 (sns)... CREATING

This will provision an SNS topic. Creation will take a few moments. To check the status use `convox resources info`.

### Additional Options

<table>
  <tr><th>Option</th><th>Description</th></tr>
  <tr><td><code>--name=<b><i>&lt;name&gt;</i></b></code></td><td>The name of the resource to create</td></tr>
  <tr><td><code>--queue=<b><i>&lt;queue&gt;</i></b></code></td><td>The name of the SQS Queue that should subscribe to this topic</td></tr>
</table>

## Resource Information

To see relevant info about the SNS topic, use the `convox resources info` command:

    $ convox resources info sns-3331
    Name    sns-3331
    Status  running
    Exports
      URL: sns://AKIBJIUUHXA6ZS4IOQIQ:ETq/IKs1OfSnLV4UC26eayufmVi1W0AJEEmbIyzh@arn:aws:sns:us-east-1:235997312769:development-sns-3331

## Resource Deletion

To delete the SNS topic, use the `convox resources delete` command:

    $ convox resources delete sns-3331
    Deleting sns-3331... DELETING
