#!/usr/bin/env bash
# Adapted from https://jimangel.io/post/create-a-vm-template-ubuntu-18.04/

##################
### Set Colors ###
##################
red=`tput -Txterm setaf 1;tput -Txterm bold`
green=`tput -Txterm setaf 2;tput -Txterm bold`
yellow=`tput setaf 3;tput bold`
blue=`tput setaf 4;tput bold`
magenta=`tput setaf 5;tput bold`
cyan=`tput setaf 6;tput bold`
white=`tput setaf 7;tput bold`
reset=`tput -Txterm sgr0`

if [ "$(whoami)" == "root" ]
then
	echo "Ok, running as root"
else
	echo "${red}Script must be run as root${reset}"
	exit 1
fi

echo "${yellow}Installing base packages.${reset}"
apt-get update
apt-get install -y git yadm screen snmpd snmp libsnmp-dev 


echo "${yellow}Halting rsyslog.${reset}"
#Stop services for cleanup
sudo service rsyslog stop
echo "${yellow}Truncating logs.${reset}"
sudo truncate -s0 /var/log/wtmp
sudo truncate -s0 /var/log/lastlog

echo "${yellow}cleaning temp folders.${reset}"
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

echo "${yellow}cleaning ssh keys.${reset}"
sudo rm -f /etc/ssh/ssh_host_*

echo "${yellow}Writing context script to /etc/rc.local .${reset}"
cat <<EOL | sudo tee /etc/rc.local
#!/bin/sh -e
apt-get update
apt-get upgrade -y
# dynamically create hostname
if hostname | grep localhost; then
    hostnamectl set-hostname $(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')
fi

test -f /etc/ssh/ssh_host_dsa_key || dpkg-reconfigure openssh-server
exit 0
EOL

sudo chmod +x /etc/rc.local

#reset hostname
# prevent cloudconfig from preserving the original hostname
sudo sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg
sudo truncate -s0 /etc/hostname
sudo hostnamectl set-hostname localhost

#cleanup apt
sudo apt clean

# cleans out all of the cloud-init cache / logs - this is mainly cleaning out networking info
sudo cloud-init clean --logs

#cleanup shell history
history -c
history -w
poweroff
