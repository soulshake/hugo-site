---
author: Noah Zoschke
date: 2016-11-07T00:00:00Z
subtitle: Table Stakes for Compliance
title: Encryption at Rest
twitter: nzoschke
url: /2016/11/07/encryption-at-rest/
---

HIPAA and PCI both have strict requirements around "encrypting data at rest."

AWS [Key Management Service](https://aws.amazon.com/kms/) (KMS), a managed service that offers API access to a Hardware Security Module (HSM), makes encrypting data at rest so easy and cost effective that all systems, not just those with strict compliance needs, should consider using it.

At Convox, we use encryption at rest with KMS for app environment variables, which can contain sensitive secrets like database credentials in a `DATABASE_URL` variable.

A KMS key costs $1/month and offers priceless security.

<!--more-->

## Encryption Pitfalls

Encryption is hard to get right. Common mistakes are:

- Not using encryption at all
- Generating a poor encryption key that can be guessed or brute-forced by an attacker
- Leaking the key to an attacker
- Using a poor algorithm to produce a cyphertext from a plaintext and the encryption key
- Leaking cyphertexts to an attacker

HIPAA and PCI compliance have strict requirements around this because the stakes are so high. One mistake with the encryption strategy and medical records and financial data are owned by attackers (or ex-employees)!

With KMS, all these challenges are addressed and made easy.

KMS is backed by a [Hardware Security Module](https://en.wikipedia.org/wiki/Hardware_security_module) (HSM), a specialized computer for generating and storing keys. An HSM is designed to be tamper-proof both in the hardware and software layer. Somewhere deep in the AWS datacenters is a secure enclave managing master keys for Netflix, banks, and our systems at Convox.

From there everything follows as API access to the HSM.

The simplest API call is [Encrypt](http://docs.aws.amazon.com/kms/latest/APIReference/API_Encrypt.html). With this you POST data to the KMS service. KMS will then access the HSM to get a secret key, apply the [industry-best AES 256 encryption algorithm](http://docs.aws.amazon.com/kms/latest/developerguide/crypto-intro.html),  and return a cyphertext. What is truly special is that the key never leaves the KMS service, so there is no chance that we accidentally leak it.

An API call to [Decrypt](http://docs.aws.amazon.com/kms/latest/APIReference/API_Decrypt.html) reverses the process, taking a cyphertext and decoding it inside the KMS service, again not exposing the key.

## Auditing

The one catch is that we are putting all our trust into the black box service that is KMS. How do we know that an attacker (or AWS itself!) isn’t also decrypting data? That’s where another compliance strategy comes in: Auditing.

[KMS is integrated with the CloudTrail auditing service](http://docs.aws.amazon.com/kms/latest/developerguide/logging-using-cloudtrail.html). Every Encrypt and Decrypt API call is recorded for near real-time monitoring, and periodic reporting.

## KMS in Action

Let’s see how KMS works. For this demo you’ll need an AWS account, with CloudTrail enabled. We will:

1. Create a KMS master key
2. Encrypt a plaintext message
3. Store data in S3, encrypted at rest
4. Fetch data from S3 and decrypt
5. Review the audit log

### Create KMS master key

First we create a master key. Somewhere deep inside Amazon a random, secure key is generated for us. We'll **never** see the value of this key--we will only use its key ID and the KMS APIs.

```bash
$ aws kms list-keys
{
    "Keys": [
    ]
}

$ aws kms create-key
{
    "KeyMetadata": {
        "KeyId": "32eda7ac-25d1-4700-b988-c11cc93746d8", 
        "Description": "", 
        "Enabled": true, 
        "KeyUsage": "ENCRYPT_DECRYPT", 
        "KeyState": "Enabled", 
        "CreationDate": 1478372635.906, 
        "Arn": "arn:aws:kms:us-east-1:132866487567:key/32eda7ac-25d1-4700-b988-c11cc93746d8", 
        "AWSAccountId": "132866487567"
    }
}

$ aws kms list-keys
{
    "Keys": [        {
            "KeyArn": "arn:aws:kms:us-east-1:132866487567:key/32eda7ac-25d1-4700-b988-c11cc93746d8", 
            "KeyId": "32eda7ac-25d1-4700-b988-c11cc93746d8"
        }
    ]
}
```

### Encrypt data

Now we can use the key ID to encrypt data. Note: this only works with less than 4KB of data. To encrypt more than 4KB of data, a [Data Key](http://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#data-keys) must be used.

```bash
$ aws kms encrypt --key-id 32eda7ac-25d1-4700-b988-c11cc93746d8 --plaintext secret
{
    "KeyId": "arn:aws:kms:us-east-1:132866487567:key/32eda7ac-25d1-4700-b988-c11cc93746d8", 
    "CiphertextBlob": "AQECAHjwV8oX1iWCacewflcKEBK8TQeayhBoRZRJkM4/p6peUgAAAGQwYgYJKoZIhvcNAQcGoFUwUwIBADBOBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDMo2cRzSf6ENVbTSrwIBEIAhS8w6e0dFTXxKp9eOvHoYArOfW7juEq8kwX+++QCprAQO"
}
```

### Store in S3 encrypted at rest

We can save the cyphertext returned from the encrypt call to disk then upload it to S3. This data is **encrypted at rest**. Mission accomplished.

```bash
$ aws kms encrypt --key-id 32eda7ac-25d1-4700-b988-c11cc93746d8 --plaintext secret --query CiphertextBlob --output text | base64 --decode > /tmp/encrypted

$ xxd /tmp/encrypted 
00000000: 0101 0200 78f0 57ca 17d6 2582 69c7 b07e  ....x.W...%.i..~
00000010: 570a 1012 bc4d 079a ca10 6845 9449 90ce  W....M....hE.I..
00000020: 3fa7 aa5e 5200 0000 6430 6206 092a 8648  ?..^R...d0b..*.H
00000030: 86f7 0d01 0706 a055 3053 0201 0030 4e06  .......U0S...0N.
00000040: 092a 8648 86f7 0d01 0701 301e 0609 6086  .*.H......0...`.
00000050: 4801 6503 0401 2e30 1104 0c97 649b 7565  H.e....0....d.ue
00000060: 4e87 7b50 8bf6 3f02 0110 8021 4b48 c577  N.{P..?....!KH.w
00000070: 4148 1b7d b360 26f5 6834 72e1 1d8a 359e  AH.}.`&.h4r...5.
00000080: 7dd4 7d58 17be 56a8 b0b1 3709 61         }.}X..V...7.a

$ aws s3 mb s3://secrets-1o9j53zqcpce9
make_bucket: s3://secrets-1o9j53zqcpce9/

$ aws s3 cp /tmp/encrypted s3://secrets-1o9j53zqcpce9/
upload: /tmp/encrypted to s3://secrets-1o9j53zqcpce9/encrypted

$ rm /tmp/encrypted
```

### Fetch from S3 and decrypt

We can download the cyphertext again. Its contents are jibberish until we decrypt it. Note that we don't specify the key ID. The data has the key ID encoded into it.

```bash
$ aws s3 cp s3://secrets-1o9j53zqcpce9/encrypted /tmp
download: s3://secrets-1o9j53zqcpce9/encrypted to /tmp/encrypted

$ aws kms decrypt --ciphertext-blob fileb:///tmp/encrypted  --output text --query Plaintext | base64 --decode
secret
```

### Review audit log

Finally we can audit the key usage. CloudTrail events are saved to files in an S3 bucket. When we search through these we see all the actions performed against the key ID. We see 3 `aws` CLI calls, as well as a web browser action.

```bash
$ aws s3 ls s3://cloudtrail-1o9j53zqcpce9/AWSLogs/132866487567/CloudTrail/us-east-1/2016/11/05/
2016-11-05 12:26:47       3364 132866487567_CloudTrail_us-east-1_20161105T1920Z_HKxz3k4q2i0A21BM.json.gz
2016-11-05 12:26:42       2566 132866487567_CloudTrail_us-east-1_20161105T1925Z_snsfeieEsmZHCmxp.json.gz
2016-11-05 12:26:34       3503 132866487567_CloudTrail_us-east-1_20161105T1925Z_z2AgljL3GILdLdzz.json.gz

$ aws s3 cp --recursive s3://cloudtrail-1o9j53zqcpce9/AWSLogs/132866487567/CloudTrail/us-east-1/2016/11/05/ .
Download: 132866487567_CloudTrail_us-east-1_20161105T1920Z_HKxz3k4q2i0A21BM.json.gz
Download: 132866487567_CloudTrail_us-east-1_20161105T1925Z_snsfeieEsmZHCmxp.json.gz
Download: 132866487567_CloudTrail_us-east-1_20161105T1925Z_z2AgljL3GILdLdzz.json.gz

$ gunzip *.gz

$ jq '.Records[] | select(.resources) | select(.resources[].ARN | endswith("32eda7ac-25d1-4700-b988-c11cc93746d8")) | {eventTime, eventSource, eventName, sourceIPAddress, userAgent}' *.json
{
  "eventTime": "2016-11-05T19:20:28Z",
  "eventSource": "kms.amazonaws.com",
  "eventName": "CreateKey",
  "sourceIPAddress": "24.6.36.168",
  "userAgent": "aws-cli/1.10.0 Python/2.7.11 Darwin/16.0.0 botocore/1.3.22"
}
{
  "eventTime": "2016-11-05T19:28:00Z",
  "eventSource": "kms.amazonaws.com",
  "eventName": "Encrypt",
  "sourceIPAddress": "24.6.36.168",
  "userAgent": "aws-cli/1.10.0 Python/2.7.11 Darwin/16.0.0 botocore/1.3.22"
}
{
  "eventTime": "2016-11-05T19:29:27Z",
  "eventSource": "kms.amazonaws.com",
  "eventName": "Decrypt",
  "sourceIPAddress": "24.6.36.168",
  "userAgent": "aws-cli/1.10.0 Python/2.7.11 Darwin/16.0.0 botocore/1.3.22"
}
{
  "eventTime": "2016-11-05T19:41:55Z",
  "eventSource": "kms.amazonaws.com",
  "eventName": "DescribeKey",
  "sourceIPAddress": "24.6.36.168",
  "userAgent": "Coral/Netty"
}
```

## Conclusion

Encryption at rest and auditing are requirements for HIPAA and PCI compliance. 

KMS and CloudTrail make this a solved problem that is easy to add to any system. KMS addresses the biggest challenges around generating keys, encrypting and decrypting data with them, and auditing access through its API.

We use KMS and encryption at rest for Convox environment variables because it’s easy. It's almost impossible to build a more secure system at any cost, but KMS costs a mere $1/month.

Why aren’t you using KMS or an HSM for your important secrets?
