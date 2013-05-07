#
# Cookbook Name:: emacs
# Provider:: package
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

  # write out the .el file
  el_file = "(setq package-archives '("
  el_file += '("gnu" . "http://elpa.gnu.org/packages/")' if new_resource.elpa
  el_file += '("marmalade" . "http://marmalade-repo.org/packages/")' if new_resource.marmalade
  el_file += '("melpa" . "http://melpa.milkbox.net/packages/")' if new_resource.melpa
  el_file += "(\"custom\" . \"#{new_resource.archive}\")" if new_resource.archive
  el_file += "))"
  el_file += "(package-refresh-contents)"
  el_file += "(package-install '#{new_resource.package})"

  execute "emacs -batch -l #{Chef::Config[:file_cache_path]}/#{new_resource.package}.el" do
    user new_resource.user
    action :nothing
  end

  file "#{Chef::Config[:file_cache_path]}/#{new_resource.package}.el" do
    owner new_resource.user
    mode 00644
    content el_file
    action :create
    notifies :run, "execute[emacs -batch -l #{Chef::Config[:file_cache_path]}/#{new_resource.package}.el]"
  end
end

action :remove do
  if new_resource.user == 'root'
    Dir.chdir("/root/.emacs.d/elpa")
  else
    Dir.chdir("/home/#{new_resource.user}/.emacs.d/elpa")
  end
  # wildcard because version is unknown
  dir = Dir.glob("#{new_resource.package}*")
  unless dir.empty?
    directory dir[0] do
      recursive true
      action :delete
    end
  end
end
