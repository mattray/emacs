#
# Cookbook Name:: emacs
# Provider:: elpa
#
# Copyright 2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

version = Chef::Version.new(Chef::VERSION)
use_inline_resources if version.major >= 11

def whyrun_supported?
  true
end

action :add do
  unless node['emacs']['install24']
    Chef::Application.fatal!("emacs_package requires node['emacs']['install24'] to be true.")
  end

  directory elpa_dir(new_resource.user, new_resource.directory) do
    owner new_resource.user
    recursive true
  end

  # write out the .el file
  el_file = "(require 'package)\r"
  el_file += "(package-initialize)\r"
  el_file += "(setq package-archives '("
  el_file += "(\"custom\" . \"#{new_resource.archive}\")" if new_resource.archive
  el_file += '("gnu" . "http://elpa.gnu.org/packages/")'
  el_file += '("marmalade" . "http://marmalade-repo.org/packages/")'
  el_file += '("melpa" . "http://melpa.milkbox.net/packages/")))'
  el_file += "\r(package-refresh-contents)\r"
  el_file += "(package-install '#{new_resource.package})\r"

  execute "installing #{new_resource.package}.el" do
    command "emacs -batch -l #{Chef::Config[:file_cache_path]}/#{new_resource.package}.el"
    user new_resource.user
    action :nothing
  end

  file "#{Chef::Config[:file_cache_path]}/#{new_resource.package}.el" do
    owner new_resource.user
    mode 00644
    content el_file
    action :create
    notifies :run, "execute[installing #{new_resource.package}.el]"
  end
end

action :remove do
  Dir.chdir(elpa_dir(new_resource.user, new_resource.directory))
  # wildcard because version is unknown
  dir = Dir.glob("#{new_resource.package}*")
  unless dir.empty?
    directory dir[0] do
      recursive true
      action :delete
    end
  end
end

def elpa_dir(user,dir)
  return dir if user.eql?('root') #whatever it is, return it
  if dir.eql?('/root/.emacs.d/elpa') #assume want it changed
    return "/home/#{user}/.emacs.d/elpa"
  end
  return dir
end
