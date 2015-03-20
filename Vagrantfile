# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant file to test riak_nagios plugin

Vagrant.configure(2) do |config|
  config.vm.box = "phusion/ubuntu-14.04-amd64"
  config.vm.provision "shell", inline: <<-SHELL
echo deb http://apt.newrelic.com/debian/ newrelic non-free >> /etc/apt/sources.list.d/newrelic.list
wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -
apt-get update
apt-get install -y curl git newrelic-sysmond screen bundler
curl -s https://packagecloud.io/install/repositories/basho/riak/script.deb | bash
apt-get install -y riak
echo "ulimit -n 65536" > /etc/default/riak
apt-get install -y newrelic-sysmond
LIC=$(cat /vagrant/newrelic.key)
nrsysmond-config --set license_key=$LIC
/etc/init.d/newrelic-sysmond start
service riak start
cd /vagrant
cp config/newrelic_plugin.example.yml config/newrelic_plugin.yml
perl -pi -e "s/LICENSE/$LIC/" /vagrant/config/newrelic_plugin.yml
#perl -pi -e "s/verbose:.*/verbose: 1/" /vagrant/config/newrelic_plugin.yml
bundle install
screen -d -m -L bundle exec ./riak_agent.rb

  SHELL
end
