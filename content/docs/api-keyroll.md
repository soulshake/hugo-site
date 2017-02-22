---
title: "API Keyroll"
order: 350
---

There are two different concepts here: rolling (changing) a **Rack API key** (what Console uses to authenticate with Rack) and rolling your **user** (or **account**) **API key**.

### Roll User/Account API Key

Each Convox account has its own API key (not to be confused with the account password).

| **CLI instructions**                  | **Console instructions**                      |
| n/a                                   | "Regenerate API key" (Account API Key page)   |

If you're trying to roll your user API key, you can do that on the [API Key page](https://console.convox.com/grid/user/api_key).

Click **Regenerate API Key**. Make sure to store the new API key that will be displayed.

Note that rolling your account API key will disable CLI access until you run `convox login console.convox.com`.


### Roll Rack API key (née "password")

A Rack has a master API key (previously referred to as a "password").

**The preferred method of rolling the Rack API key is by clicking the "Roll API key" button from the Rack settings page in the [Convox web console](https://console.convox.com).**

The “Roll API key” button in Console:

* Generates a random string to use as the Rack API key
* runs `convox rack params set Password=SomeLongRandomString123`
* stores a masked version of `SomeLongRandomString123` in the Rack record in Console
* brokers individual user access via user API keys (on organizations with Pro plans and above, this can include more than one user; see [Access Control](/docs/access-control/).

**The randomly generated Rack API key will not be revealed to you.** Rather, Console stores Rack API keys and acts as a proxy, brokering individual user access to the Rack via User API keys. Therefore, you don't need the API key since you don't need to log into the Rack directly. Instead, you should run `convox login console.convox.com` and then `convox/switch` to activate the Rack.

Note: The Rack will be unavailable during the keyroll. (See FAQ below for explanation.)

#### Other ways to change Rack API keys

| **CLI instructions**                  | **Convox Console instructions**               | **AWS Console instructions**                         |
| `convox rack params set Password=`    | "Roll API key" (Rack settings page)           | Change `Password` parameter in CloudFormation stack  |


If you want to set your own Rack API key, you can do by passing the `--password` flag during `convox install`, or later by running `convox rack params set Password=YourNewPassword`.

If you ever need to bypass Convox altogether to reset the Rack API key manually (i.e. if console.convox.com is down), you can do so by updating the `Password` parameter in your CloudFormation stack in the AWS console (**Options** -> **Update Stack** -> **Use current template** -> **Password**).

Note that resetting the Rack API key manually will cause Console to lose its connection to the Rack. You will need to remove and re-add the Rack to Console with the new API key.


### Why is the Rack is unavailable during an API key roll?

The Rack will be temporarily unavailable during the keyroll. This is because Console generates a new API key, kicks off a CloudFormation update (to update the Rack's Password param), then stores the new key in DynamoDB. But it takes a while for the CloudFormation update to complete, and until it does, Console is trying to use the new key, whereas the Rack API still has the old key.


## See also

- [API Keys](/docs/api-keys)
- [Login and authentication](/docs/login-and-authentication/)
- [CLI configuration files](/docs/cli-config-files/)
- [CLI environment variables](/docs/cli-environment-variables/)

