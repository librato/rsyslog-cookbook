#
# Cookbook Name:: rsyslog
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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

# Remove the rsyslog package if installed
package 'rsyslog' do
  action :purge
end

%w{ gnutls-bin libgnutls-dev gcc pkg-config }.each do |pkg|
  package pkg do
    action :install
  end
end

filename = "rsyslog-%s" % node[:rsyslog][:version]
url = "http://rsyslog.com/files/download/rsyslog/#{filename}.tar.gz"

remote_file "#{Chef::Config[:file_cache_path]}/#{filename}.tar.gz" do
  source url
  mode "0644"
  checksum node[:rsyslog][:checksum]
end

bash "extract_rsyslog" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
  tar zxf #{filename}.tar.gz
  EOH
  only_if { !File.exist?("#{Chef::Config[:file_cache_path]}/#{filename}") }
end

bash "install_rsyslog" do
  user "root"
  cwd "#{Chef::Config[:file_cache_path]}/#{filename}"
  code <<-EOH
  ./configure --libdir=/usr/lib --sbindir=/usr/sbin \
      --enable-gnutls \
      --enable-imfile \
      --enable-imtemplate \
      --enable-omtemplate && \
  make install
  EOH
  only_if { !File.exist?("#{Chef::Config[:file_cache_path]}/#{filename}/tools/rsyslogd") }
end

cookbook_file "/etc/init/rsyslog.conf" do
  source "rsyslog.upstart.conf"
  owner "root"
  group "root"
  mode 0644
end

service "rsyslog" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :reload => true
  action [:start]
end

cookbook_file "/etc/default/rsyslog" do
  source "rsyslog.default"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "rsyslog"), :delayed
end

directory "/etc/rsyslog.d" do
  owner "root"
  group "root"
  mode 0755
end

directory node[:rsyslog][:work_dir] do
  owner "root"
  group "root"
  mode 0700
end

template "/etc/rsyslog.conf" do
  source "rsyslog.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "rsyslog"), :delayed
end

if platform?("ubuntu")
  template "/etc/rsyslog.d/50-default.conf" do
    source "50-default.conf.erb"
    backup false
    owner "root"
    group "root"
    mode 0644
    notifies :restart, resources(:service => "rsyslog"), :delayed
  end
end
