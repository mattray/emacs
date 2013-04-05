Description
===========

Installs the "emacs" package to install the worlds most flexible, customizable text editor.

Requirements
============

## Platform

* Debian/Ubuntu
* Red Hat/CentOS/Scientific/Fedora/Arch
* FreeBSD

Should work on any platform that has a default provider for the `package` resource and a package named `emacs` avaialble in the default package manager repository.

On FreeBSD, Chef version 0.10.6 is required for fixes to the ports package provider.

Attributes
==========

* `node['emacs']['24']` - Whether to use an upstream provider for Emacs 24, currently Ubuntu-only. Defaults to `false`.
* `node['emacs']['packages']` - An array of Emacs package names to install. Defaults to the "No X11" name based on platform and falls back to "emacs".

Recipes
=======

default
-------

Installs the emacs package.

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

Managing Packages
-----------------

This LWRP provides an easy way to manage additional [ELPA](http://www.emacswiki.org/emacs/ELPA) packages.

# Actions

- :add: installs the ELPA package
- :remove: removes the ELPA package

# Attribute Parameters

- package: name attribute. The name of the package to install
- archive: URL to download packages from
- user: the user to install packages for
- elpa: use the [GNU](http://elpa.gnu.org) repo from http://elpa.gnu.org/packages/ - value can be `true` or `false`, default `true`.
- marmalade: use the [Marmalade](http://marmalade-repo.org) repo from http://marmalade-repo.org/packages/ - value can be `true` or `false`, default `false`.
- melpa: use [Milkypostman’s Emacs Lisp Package Archive](http://melpa.milkbox.net) from http://melpa.milkbox.net/packages/ - value can be `true` or `false`, default `false`.

# Examples

```ruby
#coffee-mode from elpa
emacs_package "coffee-mode"
```

```ruby
emacs_package "ac-helm" do
  melpa true
end
```

```ruby
#remove coffee-mode
emacs_package "nostinkingcoffee" do
  package "coffee-mode"
  action :remove
end
```

License and Author
==================

Author:: Joshua Timberman <joshua@opscode.com>

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
