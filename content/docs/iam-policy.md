---
title: "IAM Policy"
---

## Convox Rack IAM Policy for AWS

Certain AWS permissions are required to successfully install (and uninstall) a Convox Rack. As Rack takes advantage of many AWS services, the best way to set these permissions securely is to leverage a managed [IAM Policy](http://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html).

## Creating an IAM Policy
1. From the [IAM Policy dashboard](https://console.aws.amazon.com/iam/home#policies), select **Create Policy**.
2. Select **Create Your Own Policy**.
3. Fill in the **Policy Name** and **Description** as you like. For example:
  - Name: `ConvoxRackInstall`
  - Description: `Policy to install and uninstall a Convox Rack`
4. For **Policy Document**, copy and paste the [Convox IAM Policy](#convox-iam-policy) from below.
5. Click **Validate Policy** to make sure the policy is valid.
6. Click **Create Policy**.

## Using an IAM Policy
With the newly created policy, all that's left is to attach it to a user or group. While it varies depending on the organization, attaching the policy to an existing user is usually the most straightforward.

### To create a new user (skip this step if a user already exists):
1. From the [IAM User dashboard](https://console.aws.amazon.com/iam/home#users), select **Add user**.
2. Enter a username (e.g. `convox`). Select the "Programmatic access" checkbox and click **Next: Permissions**.
3. Select the "Attach existing policies directly" button at the top. Select the `ConvoxRackInstall` policy you just created, then click **Next: Review**. If everything looks OK, click **Create user**.
4. On the next screen, click the **Download .csv** button, and save the resulting file (we recommend saving it in your AWS config directory, e.g. `~/.aws/credentials.csv`, or `~/.aws/credentials-convox.csv` if that file already exists). Then click **Close**.

### To attach an IAM policy for a user:
1. From the [IAM User dashboard](https://console.aws.amazon.com/iam/home#users), click on the name of the user who will use the install policy.
2. Click on the **Add permissions** button on the **Permissions** tab.
3. Select the "Attach existing policies directly" button at the top. Select the checkbox next to the `ConvoxRackInstall` policy you just created, then click **Next: Review**. If everything looks OK, click the **Add permissions** button.

<div class="block-callout block-show-callout type-info" markdown="1">
With the IAM permissions in place, the next step is to [install a Rack](/docs/installing-a-rack).
</div>



## Convox IAM Policy
```
{
    "Version": "2012-10-17",
    "Statement": [{
        "Action": [
          "autoscaling:CreateAutoScalingGroup",
          "autoscaling:CreateLaunchConfiguration",
          "autoscaling:DeleteAutoScalingGroup",
          "autoscaling:DeleteLaunchConfiguration",
          "autoscaling:DeleteLifecycleHook",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DisableMetricsCollection",
          "autoscaling:EnableMetricsCollection",
          "autoscaling:PutLifecycleHook",
          "autoscaling:UpdateAutoScalingGroup",

          "cloudformation:CreateStack",
          "cloudformation:DeleteStack",
          "cloudformation:DescribeStackEvents",
          "cloudformation:DescribeStackResources",
          "cloudformation:DescribeStacks",

          "dynamodb:CreateTable",
          "dynamodb:DeleteTable",
          "dynamodb:DescribeTable",

          "ec2:AllocateAddress",
          "ec2:AssociateRouteTable",
          "ec2:AttachInternetGateway",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateInternetGateway",
          "ec2:CreateKeyPair",
          "ec2:CreateNatGateway",
          "ec2:CreateNetworkInterface",
          "ec2:CreateRoute",
          "ec2:CreateRouteTable",
          "ec2:CreateSecurityGroup",
          "ec2:CreateSubnet",
          "ec2:CreateTags",
          "ec2:CreateVpc",
          "ec2:DeleteInternetGateway",
          "ec2:DeleteNatGateway",
          "ec2:DeleteNetworkInterface",
          "ec2:DeleteRoute",
          "ec2:DeleteRouteTable",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteSubnet",
          "ec2:DeleteVpc",
          "ec2:DescribeAddresses",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeNatGateways",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "ec2:DetachInternetGateway",
          "ec2:DisassociateRouteTable",
          "ec2:ModifyVpcAttribute",
          "ec2:ReleaseAddress",

          "ecs:CreateCluster",
          "ecs:CreateService",
          "ecs:DeleteCluster",
          "ecs:DeleteService",
          "ecs:DescribeServices",
          "ecs:UpdateService",

          "elasticfilesystem:CreateFileSystem",
          "elasticfilesystem:CreateMountTarget",
          "elasticfilesystem:CreateTags",
          "elasticfilesystem:DeleteFileSystem",
          "elasticfilesystem:DeleteMountTarget",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeMountTargets",

          "elasticloadbalancing:ConfigureHealthCheck",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateLoadBalancerPolicy",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",

          "iam:AddRoleToInstanceProfile",
          "iam:CreateInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",

          "kms:CreateKey",

          "lambda:AddPermission",
          "lambda:CreateFunction",
          "lambda:DeleteFunction",
          "lambda:GetFunctionConfiguration",
          "lambda:InvokeFunction",
          "lambda:RemovePermission",

          "logs:CreateLogGroup",
          "logs:DeleteLogGroup",
          "logs:DeleteSubscriptionFilter",
          "logs:DescribeLogGroups",
          "logs:PutSubscriptionFilter",

          "s3:CreateBucket",
          "s3:GetObject",

          "sns:CreateTopic",
          "sns:CreateTopics",
          "sns:DeleteTopic",
          "sns:GetTopicAttributes",
          "sns:ListTopics",
          "sns:Subscribe"
        ],
        "Effect": "Allow",
        "Resource": "*"
    }, {
        "Sid": "LimitedIAMPermissions",
        "Effect": "Allow",
        "Action": [
          "iam:CreateAccessKey",
          "iam:CreateRole",
          "iam:CreateUser",
          "iam:DeleteAccessKey",
          "iam:DeletePolicy",
          "iam:DeleteRole",
          "iam:DeleteRolePolicy",
          "iam:DeleteUser",
          "iam:DeleteUserPolicy",
          "iam:GetRole",
          "iam:ListAccessKeys",
          "iam:PassRole",
          "iam:CreatePolicy",
          "iam:PutRolePolicy",
          "iam:PutUserPolicy",
          "iam:GetPolicy",
          "iam:AttachUserPolicy",
          "iam:DetachUserPolicy",
          "iam:ListPolicyVersions",
          "iam:GetUser"
        ],
        "Resource": [
          "arn:aws:iam::*:policy/convox/*",
          "arn:aws:iam::*:role/convox/*",
          "arn:aws:iam::*:user/convox/*"
        ]
    }
  ]
}

```
