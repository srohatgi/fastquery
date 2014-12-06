# Cookbook Name:: java
# Recipe:: set_attributes_from_version
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

# Calculate variables that depend on jdk_version
# If you need to override this in an attribute file you must use
# force_default or higher precedence.

node.default['java']['java_home'] = "/usr/lib/jvm/java-#{node['java']['jdk_version']}-#{node['java']['install_flavor']}"
# Newer Debian & Ubuntu adds the architecture to the path
if node['platform'] == 'debian' && Chef::VersionConstraint.new(">= 7.0").include?(node['platform_version']) ||
   node['platform'] == 'ubuntu' && Chef::VersionConstraint.new(">= 12.04").include?(node['platform_version'])
    node.default['java']['java_home'] = "#{node['java']['java_home']}-#{node['kernel']['machine'] == 'x86_64' ? 'amd64' : 'i386'}"
end

puts node.default['java']['java_home']
