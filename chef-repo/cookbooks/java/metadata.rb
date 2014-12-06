name              "java"
maintainer        "Socrata, Inc."
maintainer_email  "chefs@socrata.com"
license           "Apache 2.0"
description       "Installs Java runtime."
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.19.6"

recipe "java::default", "Installs Java runtime"
recipe "java::oracle", "Installs the Oracle flavor of Java"
recipe "java::oracle_i386", "Installs the 32-bit jvm without setting it as the default"
recipe "java::purge_packages", "Purges old Sun JDK packages"
recipe "java::set_attributes_from_version", "Sets various attributes that depend on jdk_version"
recipe "java::set_java_home", "Sets the JAVA_HOME environment variable"

%w{
    ubuntu
}.each do |os|
  supports os
end

suggests "aws"
