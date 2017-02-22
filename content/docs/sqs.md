---
title: "SQS"
---

<div class="alert alert-warning">
<b>Note:</b> The SQS API does not permit Convox to lock SQS resources down from the public internet.  SQS queues <b>will</b> be accessible on the public internet!
</div>

## Resource Creation

You can create SQS queues using the `convox resources create` command:

    $ convox resources create sqs
    Creating sqs-3785 (sqs)... CREATING

This will provision an SQS queue. Creation will take a few moments. To check the status use `convox resources info`.

### Additional Options

<table>
  <tr><th>Option</th><th>Description</th></tr>
  <tr><td><code>--message-retention-period=<b><i>345600</i></b></code></td><td>Seconds Amazon SQS retains a message</td></tr>
  <tr><td><code>--name=<b><i>&lt;name&gt;</i></b></code></td><td>The name of the resource to create</td></tr>
  <tr><td><code>--receive-message-wait-time=<b><i>5</i></b></code></td><td>Seconds to wait for a message to appear in the queue</td></tr>
  <tr><td><code>--visibility-timeout=<b><i>30</i></b></code></td><td>Seconds to hide a message from other components after delivery</td></tr>
</table>

## Resource Information

To see relevant info about the queue, use the `convox resources info` command:

    $ convox resources info sqs-3785
    Name    sqs-3785
    Status  running
    URL     sqs://ACCESS:SECRET@sqs.us-east-1.amazonaws.com/ACCOUNT/QUEUE

## Resource Deletion

To delete the queue, use the `convox resources delete` command:

    $ convox resources delete sqs-3785
    Deleting sqs-3785... DELETING
