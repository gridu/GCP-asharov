#!/usr/bin/env bash

########################################################
#
# Name: setup-systemd-unit.sh
#
##########################################################

set -ue ${DEBUG:+-x}

echo '===> Enabling services'
systemctl enable httpd.service

echo '===> Reloading systemd'
systemctl daemon-reload
