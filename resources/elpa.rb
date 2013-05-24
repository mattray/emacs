#
# Cookbook Name:: emacs
# Resource:: elpa
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

actions :add, :remove

def initialize(*args)
  super
  @action = :add
end

#name of the repo, used for source.list filename
attribute :package, :kind_of => String, :name_attribute => true
attribute :archive, :kind_of => String
attribute :user, :kind_of => String, :default => 'root'
attribute :directory, :kind_of => String, :default => '/root/.emacs.d/elpa'
attribute :elpa, :default => true
attribute :marmalade, :default => false
attribute :melpa, :default => false
