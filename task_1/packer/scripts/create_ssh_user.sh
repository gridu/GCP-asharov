#!/usr/bin/env bash

########################################################
#
# Name: create_ssh_user.sh
#
# Description: This script creates new ssh user.
#
##########################################################

function parse_args() {
  local OPTIND
  while getopts 'hxU:K:' opt; do
    case "${opt}" in
      h)
        show_usage
        ;;
      x)
        set -x
        ;;
      U)
        USERNAME="${OPTARG}"
        ;;
      K)
        SSH_KEY="${OPTARG}"
        ;;
      \?)
        echo "[ERROR]: Invalid option: -${opt}"
        show_usage
        exit 1;
        ;;
    esac
  done
  shift "$((OPTIND-1))"
}

function validate_args() {
  [[ -z "${USERNAME}" ]] && ( echo '[ERROR]: Username was not specified!' && exit 1)
  [[ -z "${SSH_KEY}" ]] && ( echo "[ERROR]: SSH key for ${USERNAME} was not specified!" && exit 1 )
}

function show_usage() {
  echo "${0} [-h] [-x] -U <USERNAME> -K <SSH_KEY>"
}

function disable_user() {
  local USERNAME="${1}"

  usermod -L ${USERNAME}
}

function create_ssh_user() {
    local USERNAME="${1}"
    local SSH_KEY="${2}"

    adduser "${USERNAME}"
    usermod -aG 'wheel' "${USERNAME}"

    mkdir "/home/${USERNAME}/.ssh"
    chown "${USERNAME}":"${USERNAME}" "/home/${USERNAME}/.ssh"
    echo "${SSH_KEY}" | tee "/home/${USERNAME}/.ssh/authorized_keys"

    chmod 600 "/home/${USERNAME}/.ssh/authorized_keys"
    chown "${USERNAME}":"${USERNAME}" "/home/${USERNAME}/.ssh/authorized_keys"

    # GCE
    [[ -n "$(grep google-sudoers /etc/group)" ]] && usermod -aG 'google-sudoers' "${USERNAME}" && exit 0
}

function main() {
    parse_args "${@}"
    validate_args

    disable_user 'centos'
    echo '===> User centos is disabled'

    create_ssh_user "${USERNAME}" "${SSH_KEY}"
    echo "===> User ${USERNAME} is created"
}

main "${@}"
