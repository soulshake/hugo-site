---
title: "Updating Rack and CLI"
order: 850
---

As Convox is in active development, new versions of the `convox` CLI and underlying Rack framework are frequently available.

## Updating the Convox CLI

To update the `convox` CLI tool itself, simply run `convox update` on the command line:

```
$ convox update
Updating convox/proxy: OK
Updating convox: Already up to date
```

To see if a new version is available without actually installing the update, see the `Setup` section of `convox doctor`:

```
$ convox doctor
### Setup
[✓] Convox CLI version    
[snip]
```


## Updating a Rack

There are two ways to update a Rack.

### Via the console

After logging into [the Convox web console](https://console.convox.com/), you can see your list of Racks under the `Racks` tab:

![List of Racks](/assets/images/docs/what-is-a-rack/list-of-racks.png)

If any of the Racks in the list are outdated, you can click the `Update` button to update to the next version. If the Rack is very outdated, you may need to update more than once.

### Via the `convox` CLI

You can update via the CLI by running `convox rack update [--rack <rack name>] [version]`:

```
$ convox rack update --rack dev
Updating to 20161111013816... UPDATING
```


