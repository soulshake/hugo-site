---
title: "VPC Configurations"
order: 800
---

When you [install a Rack](/docs/installing-a-rack/), most of the AWS resources used by Convox are launched inside of a new [VPC](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Introduction.html). That default behavior might not be sufficient in all cases, so we've covered a few of the common non-default VPC configurations below.

1. [Installing into an existing VPC](#installing-into-an-existing-vpc)
1. [Peering VPCs in the same region](#peering-vpcs-in-the-same-region)
1. [Connecting VPCs in different regions](#connecting-vpcs-in-different-regions)

## Installing into an existing VPC

By default, Convox Rack installations create a new VPC with subnets in two or three (when available) Availability Zones in your chosen AWS Region. If you'd like to install a Convox Rack into an existing VPC, we recommend allocating a /24 block subnet in each of three Availability Zones.

<div class="block-callout block-show-callout type-info" markdown="1">
  Your VPC must have both the `enableDnsHostnames` and `enableDnsSupport` attributes set to `true`. These settings can also be found as **Edit DNS Hostnames** and **Edit DNS Resloution** in the **Actions** menu for your VPC in the AWS VPC web console.
</div>

To install a Rack into an existing VPC, you'll need to provide:

* the VPC ID
* the VPC CIDR
* the CIDRs of the subnets into which Convox should be installed
* the Internet Gateway ID (can be found in the AWS VPC console)

```
convox install \
  --existing-vpc <VPC ID> \
  --vpc-cidr <VPC CIDR> \
  --subnet-cidrs <comma-separated CIDRs> \
  --internet-gateway <Internet Gateway ID>
```

For example:

    convox install \
      --existing-vpc "vpc-abcd1234" \
      --vpc-cidr "10.0.0.0/16" \
      --subnet-cidrs "10.0.1.0/24,10.0.2.0/24,10.0.3.0/24" \
      --internet-gateway "igw-abcd1234"

### Finding the VPC ID, VPC CIDR, and Internet Gateway ID

You can find your VPC ID and CIDR in the [AWS VPC console](https://console.aws.amazon.com/vpc). Navigate to "Your VPCs" and look in the "VPC ID" and "VPC CIDR" columns. The Internet Gateway ID can also be found in the VPC console under "Internet Gateways".

You can also list your VPCs using the AWS CLI:

```
$ aws ec2 describe-internet-gateways
```

Once you have the VPC ID you can use it to fetch the Internet Gateway ID:

```
$ aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=vpc-abcd1234"
```

### Choosing suitable CIDR blocks

Your existing VPC has a CIDR block, and each of your existing subnets has its own CIDR block within that larger VPC block. From the remaining addresses in your VPC CIDR block, you'll need to create an additional subnet in each Availability Zone in which you'd like to run Convox instances. At the moment, Convox requires three subnets with /24 CIDR blocks to give your Convox installation 254 addresses per subnet—plenty of room for typical scaling needs.

Because [VPCs cannot be resized](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html#VPC_Sizing), if your VPC does not have room for these three additional /24 CIDR blocks, you'll need to create a larger VPC and migrate your instances to it.

## Installing a private Rack into an existing VPC

Installing a private Rack into an existing VPC requires specifying a couple more options. You'll need to pass the `--private` option to `convox install` as well as a set of CIDRS for three private subnets using the `--private-cidrs` option. For example:

    convox install \
      --private \
      --existing-vpc "vpc-abcd1234" \
      --vpc-cidr "10.0.0.0/16" \
      --subnet-cidrs "10.0.1.0/24,10.0.2.0/24,10.0.3.0/24" \
      --private-cidrs "10.0.4.0/24,10.0.5.0/24,10.0.6.0/24" \
      --internet-gateway "igw-abcd1234"

Keep in mind that you will need to create six /24 CIDR block subnets: three public, and three private.

## Peering VPCs in the same region

An alternative to installing a Convox Rack into an existing VPC is to install the Rack into its own isolated VPC and then peer that VPC with another containing your non-Convox infrastructure.

> A VPC peering connection allows you to route traffic between the peer VPCs using private IP addresses; as if they are part of the same network.

The above excerpt comes from the AWS [Peering Guide](http://docs.aws.amazon.com/AmazonVPC/latest/PeeringGuide/Welcome.html), a great place to learn more about this technique.

If you are ready to set up a peering connection between two VPCs, the [Working with VPC Peering Connections](http://docs.aws.amazon.com/AmazonVPC/latest/PeeringGuide/working-with-vpc-peering.html) section of that guide walks you through the steps, which include the following and more:

* Creating a VPC Peering Connection
* Accepting a VPC Peering Connection
* Updating Route Tables for Your VPC Peering Connection
* Updating Your Security Groups to Reference Peered VPC Security Groups

Keep in mind that VPC Peering has a number of [limitations](http://docs.aws.amazon.com/AmazonVPC/latest/PeeringGuide/vpc-peering-overview.html#vpc-peering-limitations) that can complicate its setup. For example, you cannot create a VPC peering connection between VPCs that have matching or overlapping CIDR blocks, or between VPCs that exist in different regions.

## Connecting VPCs in different regions

Because VPC peering is limited to VPCs in the same region, you'll need to take a different approach to connect VPCs in different regions. At the moment, the standard practice is to run an EC2 instance in each VPC and establish an IPSec VPN connection between them. The following two guides offer step-by-step instructions for that setup.

* AWS recommends [Connecting Multiple VPCs with EC2 Instances](https://aws.amazon.com/articles/5472675506466066)
* FortyCloud's [Interconnecting Two AWS VPC Regions](http://fortycloud.com/interconnecting-two-aws-vpc-regions/) covers the same approach in greater detail

When AWS [released VPC Peering](https://aws.amazon.com/blogs/aws/new-vpc-peering-for-the-amazon-virtual-private-cloud/) in 2014, it expressed an intent to build cross-region peering in the future (see excerpt below), so keep an eye out for first-class support in AWS one of these days.

> You can connect any two VPCs that are in the same AWS Region, regardless of ownership, as long as both parties agree. We plan to extend this feature to support cross-Region peering in the future. 
