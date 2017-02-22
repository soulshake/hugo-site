---
title: "API Keys"
order: 300
---


As a Convox user, there are several authentication-related concepts you should be aware of:

1. **Convox account password**: chosen by you at signup,
2. **Convox Console API key** (one per user account): used with the CLI to log into Racks created via Console; can be regenerated at your request via Console,
3. **Rack API keys**: one per rack; can be regenerated at your request but aren't exposed to you, as they are used by Console to proxy your requests to your active Rack,
4. **Instance SSH keys**: one per Rack, applied to all the Rack's EC2 instances. You can't specify your own SSH key to be added to the instances, but they can be [re]generated via `convox instances keyroll`.


## Console API Keys

Console users have a master API key that can access all the configured Racks. If you lose this API key, you can generate a new one.

Log in to Console → Click Account → Click API Key → Click Regenerate API Key

Then you can log in from the CLI with your new API key:

```
$ convox login console.convox.com
Password: <paste API key>
```

Anytime you log into a Rack or console.convox.com, the key is stored along with the Rack hostname in `~/.convox/auth`.

The hostname of the active Rack is written to `~/.convox/rack`.

## Rack API Keys

Console encrypts and saves Rack API keys to proxy access. For security purposes you should generate new Rack API keys periodically.

Console Log In → Click Racks → Select a Rack → Click Settings → Click Roll API Key

The Rack may be temporarily unavailable while the change takes effect. For more information, see [Keyrolls](/docs/api-keyroll).


### Logging into a Rack Directly

You can bypass the console.convox.com proxy and log into a Rack directly. If you installed via `convox install`, a secure API key was generated and saved in `~/.convox/auth`. Use the hostname from `~/.convox/auth` to log into the Rack:

```
$ convox login <hostname> --password <api key>
```

If you lose the Rack key, it can not be recovered, and a new key must be set through the AWS CloudFormation Management Console.

## See also

- [API Keyroll](/docs/api-keyroll)
- [Login and authentication](/docs/login-and-authentication/)
- [CLI configuration files](/docs/cli-config-files/)
- [CLI environment variables](/docs/cli-environment-variables/)
