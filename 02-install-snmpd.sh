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
usage: $0 {read-only community}
example: $0 public
EOF
}
if [[ -z $1 ]]
then
	usage
	exit 1
fi
apt install -y snmpd
mv /etc/snmpd/snmpd.conf /etc/snmpd/snmpd.conf.orig
echo "rocommunity $1 default .1.3.6.1.2.1.1" > /etc/snmp/snmpd.conf

systemctl enable snmpd
systemctl restart snmpd
