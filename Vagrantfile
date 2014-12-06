# -*- mode: ruby -*-
# vi: set ft=ruby :

$setup_script = <<SCRIPT

# install our supported chef
sudo dpkg -i /home/vagrant/downloads/debs/chef_11.8.2-1.ubuntu.12.04_amd64.deb

sudo apt-get update

SCRIPT

$test_script = <<SCRIPT
echo "----------TESTING ALL COMPONENTS--------\n\n----------- JAVA VERSION -------------- \n"
java -version
SCRIPT

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Multimachine, define primary machine
  config.vm.define "dev", primary: true do |dev|

    # Every Vagrant virtual environment requires a box to build off of.
    dev.vm.box = "precise64"

    # The url from where the 'dev.vm.box' box will be fetched if it
    # doesn't already exist on the user's system.
    dev.vm.box_url = "http://files.vagrantup.com/precise64.box"

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    dev.vm.network :forwarded_port, guest: 8080, host: 18080
    dev.vm.network :forwarded_port, guest: 5432, host: 5432

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    dev.vm.network :private_network, ip: "192.168.33.40"

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # dev.vm.network :public_network

    # If true, then any SSH connections made will enable agent forwarding.
    # Default value: false
    # dev.ssh.forward_agent = true

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    dev.vm.synced_folder "../data", "/home/vagrant/downloads"

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    # Example for VirtualBox:
    #
    dev.vm.provider :virtualbox do |vb|
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "4096"]
    end

    dev.vm.provider :vmware_fusion do |v, override|
      override.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"
   
      v.vmx["memsize"] = "4096"
    end
    #
    # View the documentation for the provider you're using for more
    # information on available options.

    # Enable provisioning with chef solo, specifying a cookbooks path, roles
    # path, and data_bags path (all relative to this Vagrantfile), and adding
    # some recipes and/or roles.
    #
    
    dev.vm.provision :shell, inline: $setup_script
    
    dev.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "chef-repo/cookbooks"
      chef.add_recipe "java"
      chef.add_recipe "drill"
      #chef.add_recipe "postgresql"
      #chef.add_recipe "postgresql::server"
      #chef.add_recipe "elasticsearch::default"
      
      # You may also specify custom JSON attributes:
      chef.json = {
        :ip_address => '192.168.33.40',
        :chef_environment => "DEV",
        :platform => "ubuntu",
        :platform_family => "debian",
        :java => { "jdk" => { "7" => { "x86_64" => { "url" => "file:///home/vagrant/downloads/other/jdk-7u51-linux-x64.tar.gz" }}},
                   :install_flavor => "oracle" },
        :ulini => { :user => "vagrant" },
        :tomcat => { :java_options => "-Xmx1G -Xms1G -Djava.awt.headless=true" },
        :postgresql => { :password => { :postgres => "admin" } },
        :elasticsearch => { :cluster => { :name => "elasticsearch_test_chef" } }
      }
      chef.log_level = :debug
    end
    
    dev.vm.provision :shell, inline: $test_script

  end

  config.vm.define "devtools", autostart: false do |devtools|

    devtools.vm.box = "precise64"
    
    devtools.vm.provider :aws do |aws, override|

      # read aws.access_key_id     from AWS_ACCESS_KEY environment variable
      # read aws.secret_access_key from AWS_SECRET_KEY environment variable

      aws.keypair_name = "us-west-key"

      aws.ami = "ami-6e472b5e"
      aws.instance_type = "m3.medium"

      aws.region = "us-west-2"
      aws.security_groups = [ "FE", "MAINTENANCE", "OPS" ]

      aws.tags = {
        'Name' => 'OPS-devtools-2'
      }

      override.vm.box = "dummy"
      override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
      override.ssh.username = "ubuntu"
      override.ssh.private_key_path = "~/.ssh/us-west-key.pem"

    end

    $upgrade_chef_script = <<-SCRIPT
      sudo apt-get update
      sudo apt-get -y install curl
      [ ! -s chef_11.8.2-1.ubuntu.12.04_amd64.deb ] && curl -O https://s3-us-west-2.amazonaws.com/ulini-packages/chef/chef_11.8.2-1.ubuntu.12.04_amd64.deb
      sudo dpkg -i chef_11.8.2-1.ubuntu.12.04_amd64.deb
    SCRIPT

    devtools.vm.provision :shell, inline: $upgrade_chef_script

    devtools.vm.provision :chef_solo do |chef|

      chef.cookbooks_path = "chef-repo/cookbooks"
      chef.roles_path = "chef-repo/roles"
      chef.add_role("devtools")
      chef.environments_path = "chef-repo/environments"
      chef.environment = "OPS"
      chef.json = {
        :chef_environment => "OPS",
        :platform => "ubuntu",
        :platform_family => "debian",
        :ulini => { :user => "vagrant" },
        :java => { "jdk" => { "7" => { "x86_64" => { "url" => "file:///home/vagrant/downloads/other/jdk-7u51-linux-x64.tar.gz" }}},
                   :install_flavor => "oracle" },
        :jenkins => { :master => { :install_method => "package" } }
      }

      chef.log_level = :debug

    end

  end

end
