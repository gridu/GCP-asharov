#!/usr/bin/env bash

########################################################
#
# Name: cleanup.sh
#
# Description: The script make clean up
#
##########################################################

set -ue ${DEBUG:+-x}

echo '===> Performing cleanup'
rm -rf /tmp/create_ssh_user.sh