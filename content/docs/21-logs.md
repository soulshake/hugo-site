---
title: "App & Rack Logs"
permalink: /guide/logs/
phase: monitor
---

## App logs

You can view the live logs for a Convox application using `convox logs`:

```
$ convox logs --app convox-guide 
2016-11-18T22:47:27Z web:RXKRZUZBYZZ/1308857b3919 POST /sns/endpoint
2016-11-18T22:47:27Z worker:RXKRZUZBYZZ/22105226c091 [ 'queue',
2016-11-18T22:47:27Z worker:RXKRZUZBYZZ/22105226c091   '{"x-amz-sns-message-type":"Notification","x-amz-sns-message-id":"e854b955-d872-5618-9cc6-e9fc5f4d7b09","x-amz-sns-topic-arn":"arn:aws:sns:us-east-1:429213407369:player-production-embed-control","x-amz-sns-subscription-arn":"arn:aws:sns:us-east-1:429213407369:player-production-embed-control:966d0959-5c83-4721-8d14-52bd7802b05b","content-length":"981","content-type":"text/plain; charset=UTF-8","host":"ec2-54-89-52-177.compute-1.amazonaws.com","connection":"Keep-Alive","user-agent":"Amazon Simple Notification Service Agent","accept-encoding":"gzip,deflate"}' ]
2016-11-18T22:47:37Z web:RXKRZUZBYZZ/1308857b3919 HEAD /
2016-11-18T22:47:37Z worker:RXKRZUZBYZZ/22105226c091 [ 'queue', '{}' ]
2016-11-18T22:48:22Z web:RXKRZUZBYZZ/1308857b3919 POST /sns/endpoint
```

You can tie all these together to generate a report from the logs from a single container over the last 2 days:

```
$ convox ps
ID            NAME  RELEASE      SIZE  STARTED     COMMAND
310481bf223f  web   RSPZQWVWGOP  256   2 days ago  bin/web
5e3c8576b942  web   RSPZQWVWGOP  256   2 days ago  bin/web

$ convox logs --app convox-guide --filter=RXKRZUZBYZZ --since=48h --follow=false
2016-11-16T23:36:27Z web:RXKRZUZBYZZ/1308857b3919 POST /sns/endpoint
2016-11-16T23:36:27Z worker:RXKRZUZBYZZ/22105226c091 [ 'queue',
2016-11-16T23:36:27Z worker:RXKRZUZBYZZ/22105226c091   '{"x-amz-sns-message-type":"Notification","x-amz-sns-message-id":"ed8095fe-c7f9-5a05-8e52-c55828423f28","x-amz-sns-topic-arn":"arn:aws:sns:us-east-1:429213407369:player-production-embed-control","x-amz-sns-subscription-arn":"arn:aws:sns:us-east-1:429213407369:player-production-embed-control:966d0959-5c83-4721-8d14-52bd7802b05b","content-length":"981","content-type":"text/plain; charset=UTF-8","host":"ec2-54-89-52-177.compute-1.amazonaws.com","connection":"Keep-Alive","user-agent":"Amazon Simple Notification Service Agent","cookie":"cfid=f9a5075f-c79e-4841-ad89-f43840e524dc; cftoken=0","cookie2":"$Version=1","accept-encoding":"gzip,deflate"}' ]
2016-11-16T23:40:40Z web:RXKRZUZBYZZ/1308857b3919 POST /sns/endpoint
2016-11-16T23:40:40Z worker:RXKRZUZBYZZ/22105226c091   '{"x-amz-sns-message-type":"Notification","x-amz-sns-message-id":"cc12a806-8486-5414-b31a-f8a07431f23f","x-amz-sns-topic-arn":"arn:aws:sns:us-east-1:429213407369:player-production-embed-control","x-amz-sns-subscription-arn":"arn:aws:sns:us-east-1:429213407369:player-production-embed-control:966d0959-5c83-4721-8d14-52bd7802b05b","content-length":"981","content-type":"text/plain; charset=UTF-8","host":"ec2-54-89-52-177.compute-1.amazonaws.com","connection":"Keep-Alive","user-agent":"Amazon Simple Notification Service Agent","accept-encoding":"gzip,deflate"}' ]
...
```

## Rack logs

You can view the logs for a Convox Rack itself using the `convox rack logs` command:

```
$ convox rack logs
2016-11-18T23:07:03Z web:20161111013816/d37fdc57a272 ns=api.web at=request state=success status=200 method="GET" path="/check" elapsed=0.097
2016-11-18T23:07:03Z web:20161111013816/ec63f1d5456c ns=api.web at=request state=success status=200 method="GET" path="/check" elapsed=0.106
2016-11-18T23:07:03Z web:20161111013816/ec63f1d5456c ns=provider.aws at=fetchLogs start=1479337203306 state=error error="ThrottlingException: Rate exceeded \tstatus code: 400, request id: b817fd1a-ade3-11e6-ba87-95e097d0064f" location="/go/src/github.com/convox/rack/provider/aws/logs.go:70" elapsed=4800.443
2016-11-18T23:07:04Z web:20161111013816/ec63f1d5456c ns=provider.aws at=fetchLogs start=1479337176809 events=0 state=success end=1479337176810 elapsed=7602.089
2016-11-18T23:07:05Z web:20161111013816/ec63f1d5456c ns=provider.aws at=fetchLogs start=1479337203306 events=0 state=success end=1479337203307 elapsed=5966.282
```

For more details, see the [Logs documentation](/docs/logs).


{% include_relative _includes/next.html
  next="Set up a syslog resource"
  next_url="/guide/syslog/"
%}
