---
title: "Installing the Convox CLI"
order: 50
---

We provide a `convox` command line tool that makes building, configuring, scaling, and securing your apps easy.

Here are some of the highlights:

* `convox start` - A single command to start your development environment
* `convox deploy` - A single command to deploy your application to a Rack
* `convox rack update` - A single command to deliver API and infrastructure improvements to a Rack

You can install it via the command line:

## OS X

    $ curl -Ls https://convox.com/install/osx.zip > /tmp/convox.zip
    $ unzip /tmp/convox.zip -d /usr/local/bin

#### Homebrew

Alternatively, on OSX you can also install via Homebrew:

    $ brew install convox

**Note for Homebrew users:** You will need to update the CLI by running `convox update`. (As of November 2016, the convox Homebrew package has not yet been set up to support `brew upgrade convox`.)

## Linux

    $ curl -Ls https://convox.com/install/linux.zip > /tmp/convox.zip
    $ unzip /tmp/convox.zip -d /usr/local/bin

## Windows

Windows users can download the installer [here](https://dl.equinox.io/convox/convox/stable).

See the [Windows Reference](/docs/windows/) for details.

## CentOS

CentOS users can download the .rpm [here](https://dl.equinox.io/convox/convox/stable).

# Next steps

## Logging in to the CLI

After installing Convox, you'll need to `convox login`:

    $ convox login console.convox.com
    Password: <your Console API key>
    Logged in successfully.

## Updating the CLI

To update the CLI you can run `convox update`:

    $ convox update
    Updating convox/proxy: OK
    Updating convox: OK, 20161111173317

## Extras

You can also set up [shell auto-completion features](/docs/cli#shell-autocomplete-support) and [PS1 helpers](/docs/cli#active-rack-command-prompt-helper) for your terminal prompt.

## Further reading

For details about how to use `convox` on the command line, see the [CLI reference](/docs/cli/).
