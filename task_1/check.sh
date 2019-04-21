#!/usr/bin/env bash

LOAD_BALANCER_IP="${1}"

for TRY in {{1..3000}}; do
  IP=$(curl -s "http://${LOAD_BALANCER_IP}" | grep "Server IP" | grep -o '<b>.*</b>' | sed 's/\(<b>\|<\/b>\)//g')
  echo "$(date '+%Y-%m-%d %H%M%S') ${IP}"
done
