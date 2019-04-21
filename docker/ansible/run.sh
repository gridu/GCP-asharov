#!/usr/bin/env bash

WORKING_DIR=$( cd "$( dirname ${BASH_SOURCE[0]} )" && pwd )
IMAGE_HOME='/opt/ansible'
IMAGE='kvendingoldo/ansible:latest'

docker run -it \
  -v ${WORKDIR}:${IMAGE_HOME} \
  -w ${IMAGE_HOME} \
  ${IMAGE} \
  bash
