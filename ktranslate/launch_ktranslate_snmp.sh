#!/usr/bin/env bash

echo "Launching SNMP container"

docker run -d --name ktranslate-snmp-collector --restart unless-stopped --pull=always -p 162:1620/udp \
-v `pwd`/snmp-base.yaml:/snmp-base.yaml \
-e NEW_RELIC_API_KEY=$NET_SIM_LICENSE \
kentik/ktranslate:v2 \
  -snmp /snmp-base.yaml \
  -nr_account_id=$NET_SIM_ACCOUNT \
  -metrics=jchf \
  -tee_logs=true \
  -service_name=net-sim \
  -snmp_discovery_on_start=true \
  -snmp_discovery_min=180 \
  nr1.snmp