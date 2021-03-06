#
# Cookbook Name:: rsyslog
# Attributes:: rsyslog
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

default[:rsyslog][:log_dir] = "/srv/rsyslog"
default[:rsyslog][:server] = false
default[:rsyslog][:protocol] = "tcp"
default[:rsyslog][:work_dir] = "/var/spool/rsyslog"

# What version to install. Should follow the latest release line
default[:rsyslog][:version] = "5.8.5"
# Checksum of package file (must be updated along with version)
default[:rsyslog][:checksum] = "a519704c06de1026847f69d99f31a2a32783e9547f5249dddefe805bfbc3ea50"
