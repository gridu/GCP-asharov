#!/usr/bin/env bash

########################################################
#
# Name: install_apache.sh
#
# Description: The script install EPEL repository
#
##########################################################

set -ue ${DEBUG:+-x}

yum install -y httpd

# Create health endpoint
cat << _END_ > /etc/httpd/conf.d/server-status.conf
<Location "/health">
    SetHandler server-status
</Location>
_END_

systemctl restart httpd
