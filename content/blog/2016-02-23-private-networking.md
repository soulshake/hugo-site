---
author: David Dollar
date: 2016-02-23T00:00:00Z
title: Private Networking
twitter: ddollar
url: /2016/02/23/private-networking/
---

We are pleased to announce Convox support for private networks inside your Amazon VPCs. 

In public mode a Convox Rack launches its instances in a public subnet relying on security groups to keep out unwanted traffic. Outbound traffic from these instances goes directly to the internet.

In private mode a Convox Rack instead launches instances in private subnets and creates NAT Gateways to handle outbound traffic.

<!--more-->

Load Balancers continue to follow the existing behavior laid out in our [Port Mapping](http://convox.com/docs/port-mapping/) documentation. External load balancers in a private Rack straddle the public and private subnets and allow you to receive traffic without directly exposing your instances to the internet.

You can install a new Rack in private mode by specifying the `--private` option to `convox install`.

You can also set an existing Rack to private mode by running `convox rack params set Private=Yes`. This transition will take several minutes but should result in no downtime.

See the [Private Networking](https://convox.com/docs/private-networking/) documentation for more information.

```
┌─────┐   ┌────────────────────────────────────────────┐
│     │   │ Availability Zone                          │
│     │   │ ┌─────────────────┐ ┌────────────────────┐ │
│     │   │ │ Public Subnet   │ │ Private Subnet     │ │
│     │   │ │ ┌─────────────┐ │ │ ┌────────────┐ ┌─┐ │ │
│     ◀───┼─┼─┤ NAT Gateway ◀─┼┬┼─┤  Instance  ◀─┤ │ │ │
│     │   │ │ └─────────────┘ │││ └────────────┘ │I│ │ │
│     │   │ │ ┌───────────┐   │││ ┌────────────┐ │P│ │ │
│     ├───┼─┼─▶ Public IP │   │└┼─┤  Instance  ◀─┤ │ │ │
│     │   │ │ └─────┬─────┘   │ │ └────────────┘ └▲┘ │ │
│  I  │   │ └───────┼─────────┘ └─────────────────┼──┘ │
│  n  │   └─────────┼─────────────────────────────┼────┘
│  t  │             │                             │     
│  e  │    ┌────────▼─────────────────────────────┴──┐  
│  r  │    │                   ELB                   │  
│  n  │    └────────▲─────────────────────────────┬──┘  
│  e  │             │                             │     
│  t  │   ┌─────────┼─────────────────────────────┼────┐
│     │   │ ┌───────┼─────────┐ ┌─────────────────┼──┐ │
│     │   │ │ ┌─────┴─────┐   │ │ Private Subnet  │  │ │
│     ├───┼─┼─▶ Public IP │   │ │ ┌────────────┐ ┌▼┐ │ │
│     │   │ │ └───────────┘   │┌┼─┤  Instance  ◀─┤ │ │ │
│     │   │ │ ┌─────────────┐ │││ └────────────┘ │I│ │ │
│     ◀───┼─┼─┤ NAT Gateway ◀─┼┤│ ┌────────────┐ │P│ │ │
│     │   │ │ └─────────────┘ │└┼─┤  Instance  ◀─┤ │ │ │
│     │   │ │ Public Subnet   │ │ └────────────┘ └─┘ │ │
│     │   │ └─────────────────┘ └────────────────────┘ │
│     │   │ Availability Zone                          │
└─────┘   └────────────────────────────────────────────┘
```

We'd like to thank [Chris LeBlanc](https://github.com/cleblanc87) for [contributing](https://github.com/convox/rack/pull/214) the bulk of the work for this feature.

