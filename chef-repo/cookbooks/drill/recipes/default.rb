#
# Cookbook Name:: drill
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

drill_version = "0.6.0"
drill_pkg = "apache-drill-#{drill_version}-incubating"
drill_pkg_gz = "#{drill_pkg}.tar.gz"

remote_file "#{Chef::Config[:file_cache_path]}/#{drill_pkg_gz}"  do
  source "http://apache.claz.org/drill/drill-#{drill_version}-incubating/#{drill_pkg_gz}"
end

bash "install_drill" do
  user "root"
  cwd ::File.dirname("#{Chef::Config[:file_cache_path]}/cache")
  code <<-EOC
    mkdir -p /opt
    tar -xvzf #{drill_pkg_gz} -C /opt
    ln -s /opt/#{drill_pkg} /opt/drill
  EOC
  not_if { File.exists?("/opt/drill") }
end