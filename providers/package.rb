#
# Cookbook Name:: apt
# Provider:: repository
#
# Copyright 2010-2011, Opscode, Inc.
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

def whyrun_supported?
  true
end



action :add do
  new_resource.updated_by_last_action(false)

  # write out the .el file
  el_file = "(setq package-archives '("
  el_file += '("gnu" . "http://elpa.gnu.org/packages/")' if new_resource.elpa
  el_file += '("marmalade" . "http://marmalade-repo.org/packages/")' if new_resource.marmalade
  el_file += '("melpa" . "http://melpa.milkbox.net/packages/")' if new_resource.melpa
  el_file += "(\"custom\" . \"#{new_resource.archive}\")" if new_resource.archive
  el_file += "))"
  el_file += "(package-refresh-contents)"
  el_file += "(package-install '#{new_resource.package})"

# (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
#                            ("marmalade" . "http://marmalade-repo.org/packages/")
#                            ("melpa" . "http://melpa.milkbox.net/packages/")))
# (package-refresh-contents)
# (package-install 'coffee-mode)

  f = file "#{Chef::Config[:file_cache_path]}/#{new_resource.package}.el" do
    owner new_resource.user
    mode 00644
    content el_file
    action :create
  end

  #emacs -batch -l /var/chef/cache/coffee-mode.el
  execute "emacs -batch -l #{Chef::Config[:file_cache_path]}/#{new_resource.package}.el" do
    user new_resource.user
  end

  #new_resource.updated_by_last_action(f.updated?)
end

action :remove do
  #rm -rf ~/.emacs.d/elpa/coffee-mode-0.4.1/
  # if ::File.exists?("/etc/apt/sources.list.d/#{new_resource.name}.list")
  #   Chef::Log.info "Removing #{new_resource.name} repository from /etc/apt/sources.list.d/"
  #   file "/etc/apt/sources.list.d/#{new_resource.name}.list" do
  #     action :delete
  #   end
  # end
end
