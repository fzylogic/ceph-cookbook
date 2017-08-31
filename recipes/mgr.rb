#
# Author:: Jeremy Hanmer <jeremy@dreamhost.com>
# Cookbook Name:: ceph
# Recipe:: mgr
#
# Copyright 2017, DreamHost Web Hosting
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

include_recipe 'ceph'
include_recipe 'ceph::mgr_install'

cluster = 'ceph'

ceph_client 'mgr' do
  caps('osd' => 'allow *', 'mon' => 'allow profile mgr', 'mds' => 'allow *')
  keyname "mds.#{node['hostname']}"
  filename "/var/lib/ceph/mgr/#{cluster}-#{node['hostname']}/keyring"
end

file "/var/lib/ceph/mgr/#{cluster}-#{node['hostname']}/done" do
  owner 'root'
  group 'root'
  mode 00644
end

service_type = node['ceph']['osd']['init_style']

case service_type
when 'upstart'
  filename = 'upstart'
else
  filename = 'sysvinit'
end
file "/var/lib/ceph/mgr/#{cluster}-#{node['hostname']}/#{filename}" do
  owner 'root'
  group 'root'
  mode 00644
end

service 'ceph_mgr' do
  service_name 'ceph-mgr'
  action [:enable, :start]
  supports :restart => true
end
