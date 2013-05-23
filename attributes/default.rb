#
# Author:: Joshua Timberman <joshua@opscode.com>
# Copyright:: Copyright (c) 2011-2013, Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['emacs']['install24'] = false

case node['platform']
when 'ubuntu','debian'
  if node['emacs']['install24']
    default['emacs']['packages'] = ['emacs24-nox']
  else
    default['emacs']['packages'] = ['emacs23-nox']
  end
when 'redhat','centos','scientific','fedora','arch'
  default['emacs']['packages'] = ['emacs-nox']
when 'freebsd'
  default['emacs']['packages'] = ['editors/emacs-nox11']
else
  default['emacs']['packages'] = ['emacs']
end

default['emacs']['elpa'] = []
