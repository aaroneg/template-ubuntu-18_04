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
usage: $0 newhostname
EOF
}
if [[ -z $1 ]]
then
	usage
	exit 1
fi

if [ "$(whoami)" == "root" ]
then
	/usr/bin/hostnamectl set-hostname $1
else
	echo "${red}Script must be run as root${reset}"
	exit 1
fi
reboot
