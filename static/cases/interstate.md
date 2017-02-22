---
title: Interstate Analytics
layout: case
---

[Interstate Analytics](https://interstateanalytics.com/) helps marketers make better decisions faster. The platform collects marketing data spread across numerous channels like Facebook, Google AdWords and AdRoll to provide unique insights in the performance data. Every day Interstate Analytics is seeing more customers, and every day those customers are sending over larger volumes of marketing data.

## The Challenge: Services at Scale

The Interstate Analytics platform:

* Ingest peaks of 10,000 requests/minute of ad tracking data
* Analyze millions of data points to provide customer insights

The team needs to focus on building new analytics tools and reports for their customers.

Instead they found themselves distracted by ballooning platform costs to keep up with the volume, and worried the time, cost and complexity challenges with migrating to their own infrastructure.

## The Solution: Migrate Apps to AWS via Convox

Interstate Analytics moved their entire business onto Convox. Now they enjoy a simple and reliable platform that scales efficiently for their large Rails web servers and their hundreds of smaller analytics workers alike.

Convox supported building, deploying and scaling Interstate's Rails apps out of the box. Convox's Docker support made it possible to further customize the Rails environment, adding important optimizations needed for running at scale.

Likewise Convox supports their Python data science stack. The specialized library and memory requirements for machine learning and deep learning systems was as easy as writing another Dockerfile and deploying to a new app.

Convox made it easy to provision a massive set of dedicated resources to deploy these apps to. All of a sudden big cost challenges were replaced with the best security, performance and cost savings available in the public cloud.

Convox was set up in Interstate's own AWS account, which made it easy and secure to integrate with their with existing ElasticSearch cluster and their [Citus Data](https://www.citusdata.com/) PostgreSQL cluster.

Interstate now enjoys a single place for all their application data, logs and metrics, which is critical for operating services at their scale.

> Convox has been instrumental in helping us enjoy the flexibility of AWS. Their support, product, and team are second to none.
> - Jamie Quint

## The Architecture

* 10s of high memory (8 GB) Rails web servers and event collectors
* 10s of high memory (1 GB) Python data science workers
* 100s of small (256 MB) analytics workers
* 1 private Postgres cluster (Citus Data Master / Shards)
* 6 private Redis work queues
* ElasticSearch private log analysis

## About Interstate Analytics

Interstate Analytics is a lean startup that participated in Y Combinator 2016.
