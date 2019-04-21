#!/usr/bin/env bash

########################################################
#
# Name: init_new_role.sh
#
##########################################################

ROLES_DIR="$(pwd)"
TEMPLATE_ROLE_NAME='template-role'
TEMPLATE_ROLE_PATH="${ROLES_DIR}/${TEMPLATE_ROLE_NAME}"

function parse_args() {
  local OPTIND
  while getopts "hN:D:" opt; do
    case "${opt}" in
      h)
        show_usage
        ;;
      N)
        NEW_ROLE_NAME="${OPTARG}"
        ;;
      D)
        ROLES_DIR="${OPTARG}"
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

function show_usage() {
  echo "${0} [-h] [-D <roles_dir>] -N <new_role_name>"
}

function main () {
  parse_args "${@}"
  if [[ -z ${NEW_ROLE_NAME} ]]; then
      echo "[ERROR]: ${0}: failed to get role name. Specify role_name via -N parameter."
      exit 1
  fi
  if [[ -d ${ROLES_DIR}/${NEW_ROLE_NAME} ]]; then
      echo "[ERROR]: ${0}: failed to create new role, ${NEW_ROLE_NAME} role already exists."
      exit 1
  fi
  cp -r ${TEMPLATE_ROLE_PATH}/ ${ROLES_DIR}/${NEW_ROLE_NAME}
  for file in $(grep -lr ${TEMPLATE_ROLE_NAME} ${ROLES_DIR}/${NEW_ROLE_NAME}); do
    perl -pi -w -e "s/${TEMPLATE_ROLE_NAME}/${NEW_ROLE_NAME}/g;" ${file}
  done
}

main "${@}"
