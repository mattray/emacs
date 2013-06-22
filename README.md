Description
===========

Installs the "emacs" package to install the world's most flexible, customizable text editor.

Requirements
============

## Platform

* Debian/Ubuntu
* Red Hat/CentOS/Scientific/Fedora/Arch
* FreeBSD

Should work on any platform that has a default provider for the `package` resource and a package named `emacs` available in the default package manager repository.

On FreeBSD, Chef version 0.10.6 is required for fixes to the ports package provider.

Attributes
==========

* `node['emacs']['install24']` - Whether to use an upstream provider for Emacs 24, currently Ubuntu-only. Defaults to `false`.
* `node['emacs']['packages']` - An array of Emacs package names to install. Defaults to the "No X11" name based on platform and falls back to "emacs".

Recipes
=======

default
-------

Installs the emacs package and any ELPA packages in the list `node['emacs']['elpa']`.

Usage
=====

Simply add `recipe[emacs]` to the run list of a base role that gets applied to all systems. Modify the `node['emacs']['packages']` attribute if the default package name for your platform is unavailable or incorrect (see `attributes/default.rb`). You should modify this with an attribute in a role applied to the node. For example:

    name "base"
    description "base role is applied to all nodes"
    run_list("recipe[emacs]")
    default_attributes(
      "emacs" => {
        "packages" => ["emacs-nox"]
      }
    )

As this is an array you can append other emacs-related packages, such as to make configuration modes available.

Resources/Providers
===================

Managing ELPA Packages
----------------------

This LWRP provides an easy way to manage additional [ELPA](http://www.emacswiki.org/emacs/ELPA) packages. Requires that `node['emacs']['install24']` be set to `true`.

# Actions

- :add: installs the ELPA package
- :remove: removes the ELPA package

# Attribute Parameters

- package: name attribute. The name of the package to install
- archive: URL to download packages from if package is not part of [ELPA](http://elpa.gnu.org), [Marmalade](http://marmalade-repo.org) or [Milkypostman’s Emacs Lisp Package Archive](http://melpa.milkbox.net) which are loaded by default.
- user: the user to install packages for
- directory: where to install the packages, default is `/root/.emacs.d/elpa` for `root` or `/home/USER/.emacs/elpa` for the `user` specified by the attribute

# Examples

```ruby
#coffee-mode
emacs_elpa "coffee-mode"
```

```ruby
emacs_elpa "ac-helm"
```

```ruby
#remove coffee-mode
emacs_elpa "nostinkingcoffee" do
  package "coffee-mode"
  action :remove
end
```

License and Author
==================

Author:: Joshua Timberman <joshua@opscode.com>
Author:: Matt Ray <matt@opscode.com>

Copyright:: 2009-2013, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
