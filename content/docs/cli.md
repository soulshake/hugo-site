---
title: "CLI"
---

## Install the CLI

To install the `convox` CLI tool, see [Installing the Convox CLI](/docs/installation/).

## Convox Update

You can easily update the CLI to get bugfixes and features:

    $ convox update
    OK, 20160617165137

    $ convox --version
    client: 20160617165137
    server: 20160615213630 (console.convox.com)

## Overriding App Defaults

You can set a default app name in an app directory. Instead of inferring the default app name from the current directory name, CLI commands will default to the app name specified in `.convox/app`:

    $ cd myapp
    $ mkdir .convox
    $ echo myapp-staging > .convox/app
    $ convox apps info
    Name       myapp-staging
    ...

## Switching Between Racks

The Convox Console makes it easy to install and manage multiple Racks, like one for development, staging and production. The `convox` CLI offers a few strategies to switch between these environments.

#### Switch Command

You can use `convox racks` and `convox switch` to select a Rack that your computer will operate against by default.

    $ convox racks
    myorg/staging                    running    
    myorg/production                 running    
    personal/staging                 running

    $ convox switch production
    Switched to myorg/production

    $ convox switch staging
    ERROR: You have access to multiple racks with that name, try one of the following:
    convox/staging
    personal/staging

    $ convox switch personal/staging
    Switched to personal/staging

    $ convox switch
    personal/staging

#### Rack Flag

You can specify a specific Rack on a per-command basis with the `--rack` flag:

    $ convox switch
    myorg/staging

    $ convox apps
    APP           STATUS 
    api-staging   running
    docs-staging  running

    $ convox apps --rack personal/staging
    APP    STATUS 
    httpd  running
    rails  running

#### CONVOX_RACK Environment Variable 

You can specify a specific Rack for a new terminal session with the CONVOX_RACK environment variable:

    $ convox switch
    myorg/staging

    $ export CONVOX_RACK=personal/staging

    $ convox switch
    personal/staging

    $ convox apps
    APP    STATUS 
    httpd  running
    rails  running

#### App Repository Setting

You can set a default Rack name in an app's repository. This will take precedence over the `convox switch` setting:

    $ cd rails
    $ mkdir .convox
    $ echo personal/staging > .convox/rack
    $ convox deploy

#### Client Rack Header

All of the above tools control what `Rack` header is sent in API commands. You can also control this explicitly when using the API:

    $ curl -u :$API_KEY -H "Rack: personal/staging" https://console.convox.com/apps
    [
      {
        "name": "httpd",
        "release": "RLBTJENIMQI",
        "status": "running"
      },
      {
        "name": "rails",
        "release": "RGPIVDMTGVH",
        "status": "running"
      }
    ]

#### Precedence

The order of precedence is:

* --rack flag
* CONVOX_RACK environment variable
* ./convox/rack app repository setting
* `convox switch` default setting in ~/.convox/rack

When you want to manage multiple racks in multiple terminals you should use `CONVOX_RACK`.

When you want to pin an app to a specific Rack you should use `./convox/rack` which can only be overridden by an explicit `--rack` flag.

## Shell Autocomplete Support

The `convox` CLI offers bash autocompletion and command prompt utilities.

### OSX + Homebrew

To set this up on OS X with Homebrew, save the convox autocomplete helper in the `bash_completion.d` directory:

    $ curl -o $(brew --prefix)/etc/bash_completion.d/convox \
      https://raw.githubusercontent.com/codegangsta/cli/master/autocomplete/bash_autocomplete

then add an autocomplete initializer `~/.bash_profile`:

    echo "source $(brew --prefix)/etc/bash_completion.d/convox" >> "$HOME/.profile"

### Debian-based Linux distributions

As root, save [this bash_autocomplete snippet](https://raw.githubusercontent.com/codegangsta/cli/master/autocomplete/bash_autocomplete) in `/etc/bash_completion.d/convox`, as in the following command:

    $ curl https://raw.githubusercontent.com/codegangsta/cli/master/autocomplete/bash_autocomplete \
      | sudo tee /etc/bash_completion.d/convox

Make sure you're sourcing `/etc/bash_completion.d/convox` in your `.profile`:

    $ echo "source /etc/bash_completion.d/convox" >> "$HOME/.profile"

Now open a new tab and type `convox` and `convox builds` followed by the TAB key:
 
    $ convox <TAB>
    api         certs       exec        install     proxy       registries  services    uninstall
    apps        deploy      h           instances   ps          releases    ssl         update
    build       doctor      help        login       rack        run         start       
    builds      env         init        logs        racks       scale       switch      

    $ convox builds <TAB>
    create  delete  export  h       help    import  info    logs    

## Active Rack Command Prompt Helper

In your `.profile`, define `__convox_switch` as a function:

    __convox_switch() {
      [ -e ~/.convox/rack ] && convox switch || echo unknown;
    }

Then include `$(__convox_switch)` in your prompt (`PS1`):

    export PS1="\h:\W \u (\$(__convox_switch))\$(__git_ps1)$ "

or

    PS1+="[$(__convox_switch)] "
    export PS1

