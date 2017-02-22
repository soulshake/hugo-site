---
title: "Rack Parameters"
---

# Setting Parameters

Parameters can be set using the following command.

    convox rack params set Foo=bar

You can also set multiple parameters at once.

    convox rack params set Foo=bar Baz=qux

# Available Parameters

The following parameters can be used to configure your Convox Rack:

* [Ami](#ami)
* [ApiCpu](#apicpu)
* [ApiMemory](#apimemory)
* [Autoscale](#autoscale)
* [BuildCpu](#buildcpu)
* [BuildImage](#buildimage)
* [BuildMemory](#buildmemory)
* [ClientId](#clientid)
* [ContainerDisk](#containerdisk)
* [Development](#development)
* [Encryption](#encryption)
* [ExistingVpc](#existingvpc)
* [InstanceBootCommand](#instancebootcommand)
* [InstanceCount](#instancecount)
* [InstanceRunCommand](#instanceruncommand)
* [InstanceType](#instancetype)
* [InstanceUpdateBatchSize](#instanceupdatebatchsize)
* [Internal](#internal)
* [Key](#key)
* [Password](#password) **(required)**
* [Private](#private)
* [PrivateApi](#privateapi)
* [Subnet0CIDR](#subnet0cidr)
* [Subnet1CIDR](#subnet1cidr)
* [Subnet2CIDR](#subnet2cidr)
* [SubnetPrivate0CIDR](#subnetprivate0cidr)
* [SubnetPrivate1CIDR](#subnetprivate1cidr)
* [SubnetPrivate2CIDR](#subnetprivate2cidr)
* [SwapSize](#swapsize)
* [Tenancy](#tenancy)
* [Version](#version) **(required)**
* [VolumeSize](#volumesize)
* [VPCCIDR](#vpccidr)

## Ami

Which [Amazon Machine Image](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html) should be used.

## ApiCpu

How much CPU should be reserved by the API web process.

| Default value | `128` |

## ApiMemory

How much memory should be reserved by the API web process.

| Default value | `128` |

## Autoscale

Autoscale rack instances. See our [Scaling doc](https://convox.com/docs/scaling#autoscale) for more information.

| Default value  | `No`        |
| Allowed values | `Yes`, `No` |

## BuildCpu

How much CPU should be allocated to builds.

| Default value | `0` |

## BuildImage

Override the default build image.

| Default value | "" |

## BuildMemory

Amount of memory (in MB) allocated to builds.

| Default value  | 1024 |

## ClientId

Anonymous identifier.

| Default value  | `dev@convox.com` |

## ContainerDisk

<div class="alert alert-info">
Getting errors like <b>No space left on device</b>? You can extend the space on the device by increasing this parameter.
</div>

Default container disk size in GB.

| Default value | `10` |

## Development

Development mode.

| Default value  | `No`        |
| Allowed values | `Yes`, `No` |

## Encryption

Encrypt secrets with KMS.

| Default value    | `Yes`       |
| Permitted values | `Yes`, `No` |

## ExistingVpc

Existing VPC ID (if blank, a VPC will be created).

## InstanceBootCommand

A single line of shell script to run as a cloud-init command early during instance boot.

For more information about using cloud-init with EC2, see the AWS doc [Running Commands on Your Linux Instance at Launch](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html#user-data-cloud-init). For cloud-init specifics, see "bootcmd" in the doc [Run commands on first boot](http://cloudinit.readthedocs.io/en/latest/topics/examples.html#run-commands-on-first-boot).

| Default value | "" |

## InstanceCount

The number of EC2 instances in your Rack cluster.

| Default value | `3`    |
| Minimum value | `3`    |

## InstanceRunCommand

A single line of shell script to run as a cloud-init command late during instance boot.

For more information about using cloud-init with EC2, see the AWS doc [Running Commands on Your Linux Instance at Launch](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html#user-data-cloud-init). For cloud-init specifics, see "runcmd" in the doc [Run commands on first boot](http://cloudinit.readthedocs.io/en/latest/topics/examples.html#run-commands-on-first-boot).

| Default value | "" |

## InstanceType

The type of EC2 instance run in your Rack cluster.

| Default value  | `t2.small`                                                         |
| Allowed values | [EC2 Instance Types](https://aws.amazon.com/ec2/instance-types/) |

## InstanceUpdateBatchSize

The number of instances to update in a batch.

| Default value | `1`    |
| Minimum value | `1`    |

## Internal

Make all new apps created in the Rack use Internal ELBs by default, i.e. make them accessible only from within the VPC and unreachable from the internet. See the [Internal Racks](https://convox.com/docs/internal-apps#internal-racks) section of our Internal Apps doc for more information.

| Default value  | `No`        |
| Allowed values | `Yes`, `No` |

## Key

SSH key name for access to cluster instances.

## Password

(REQUIRED) API HTTP password.

| Minimum length  | 1  |
| Maximum length  | 50 |

## Private

Have the Rack create non-publicly routable resources, i.e. in a private subnet. See our [Private Networking doc](https://convox.com/docs/private-networking/) for more information.

| Default value  | `No`        |
| Allowed values | `Yes`, `No` |

## PrivateApi

Put Rack API Load Balancer in a private network, i.e. have the Rack API use an Internal ELB, making it unreachable from the internet.

| Default value  | `No`        |
| Allowed values | `Yes`, `No` |


## Subnet0CIDR

Public Subnet 0 CIDR Block.

| Default value | `10.0.1.0/24` |


## Subnet1CIDR

Public Subnet 1 CIDR Block.

| Default value | `10.0.2.0/24` |

## Subnet2CIDR

Public Subnet 2 CIDR Block.

| Default value | `10.0.3.0/24` |

## SubnetPrivate0CIDR

Private Subnet 0 CIDR Block.

| Default value | `10.0.4.0/24` |

## SubnetPrivate1CIDR

Private Subnet 1 CIDR Block.

| Default value | `10.0.5.0/24` |

## SubnetPrivate2CIDR

Private Subnet 2 CIDR Block.

| Default value | `10.0.6.0/24` |

## SwapSize

Default swap volume size in GB.

| Default value | `5` |

## Tenancy

Dedicated hardware.

| Default value  | `default`              |
| Allowed values | `default`, `dedicated` |

## Version

(REQUIRED) Convox release version.

| Minimum length | 1 |

## VolumeSize

Default disk size (in gibibytes) of the EBS volume attached to each EC2 instance in the cluster.

| Default value | `50` |

## VPCCIDR

VPC CIDR Block. Note that changing this has no effect since VPC CIDR ranges cannot be changed after they're created.

| Default value | `10.0.0.0/16` |


## Reference

* [rack.json](https://github.com/convox/rack/blob/b7d9a114d5cc5f0a2843b89413067466aa41bc94/provider/aws/dist/rack.json#L176) on GitHub
