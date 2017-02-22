---
author: Matt Manning
date: 2015-07-27T00:00:00Z
title: Open Source
twitter: mattmanning
url: /2015/07/27/open-source/
---

> "...as we enjoy great advantages from the inventions of others, we should be glad of an opportunity to serve others by any invention of ours; and this we should do freely and generously." -Benjamin Franklin

Convox believes in open source. We think that the inner workings of the software you depend on should be knowable. We also believe in sharing our insights with the world. When we leverage each others' creations we all benefit.

<!--more-->

A great thing about sharing is that others share back. This weekend, [Oren Golan](https://github.com/oren) dug into the Convox codebase. He's interested in using Convox for a project requiring [HIPAA compliance](http://aws.amazon.com/compliance/hipaa-compliance/). Convox isn't currently certified HIPAA compliant, but since it's open source, Oren was able to make changes toward his use case.

He added the ability to pass a **--dedicated** option to the **convox install** command and install Convox on Dedicated EC2 instances, a common choice for AWS configurations with HIPAA concerns.

[https://github.com/convox/cli/pull/41](https://github.com/convox/cli/pull/41)  
[https://github.com/convox/kernel/pull/83](https://github.com/convox/kernel/pull/83)  

Oren was kind enough to write up his work and a review of Convox on his blog. Please [check it out](http://oren.github.io/blog/convox.html).

If you're interested in contributing to Convox please check out our [Github repos](https://github.com/convox) and contact us at [core-team@convox.com](mailto:core-team@convox.com).
