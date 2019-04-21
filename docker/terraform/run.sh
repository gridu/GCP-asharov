#!/usr/bin/env bash

WORKING_DIR=$( cd "$( dirname ${BASH_SOURCE[0]} )" && pwd )
IMAGE_HOME='/opt/terraform'
IMAGE='hashicorp/terraform:latest'

docker run -it \
  -v ${WORKING_DIR}:${IMAGE_HOME} \
  -w ${IMAGE_HOME} \
  ${IMAGE} \
  bash
