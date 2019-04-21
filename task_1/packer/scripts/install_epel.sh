#!/usr/bin/env bash

########################################################
#
# Name: install_epel.sh
#
# Description: The script install EPEL repository
#
##########################################################

set -ue ${DEBUG:+-x}

curl -sSfL https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -o /tmp/epel.noarch.rpm
yum install -y /tmp/epel.noarch.rpm