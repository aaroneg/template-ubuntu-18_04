#!/usr/bin/env bash

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

usage()
{
	cat<<EOF
usage: $0 {interface} {IPv4Address} {PrefixLength} {gateway4} {searchDomain} {dnsserver}
example: $0 "ens160" "192.168.0.5" "24" "192.168.0.1" "my.example" "192.168.0.1"
EOF
}
if [[ -z $1 ]]
then
	usage
	exit 1
fi

if [ "$(whoami)" == "root" ]
then
	echo "${blue}Script running as root!${reset}"
else
	echo "${red}Script must be run as root${reset}"
	exit 1
fi
echo "${blue}Disabling old network configs.${reset}"
find /etc/netplan -name "*.yaml" -exec bash -c 'mv "$1" "${1%.yaml}".yaml.disabled' - '{}' \;
cp ./static.yaml "./$1.yaml"
sed -i "s/_INTERFACE_/$1/g" "$1.yaml"
sed -i "s/_V4ADDRESS_/$2/g" "$1.yaml"
sed -i "s/_V4PREFIX_/$3/g" "$1.yaml"
sed -i "s/_GATEWAY4_/$4/g" "$1.yaml"
sed -i "s/_SEARCHDOMAIN_/$5/g" "$1.yaml"
sed -i "s/_DNSSERVER_/$6/g" "$1.yaml"
cp "$1.yaml" /etc/netplan/
echo "${red}APPLYING NEW NETWORK CONFIG, YOU ARE NOW DISCONNECTED!${reset}"
netplan apply &
