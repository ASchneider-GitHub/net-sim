#!/usr/bin/env bash

echo "Launching netflow container"

docker run -d --name ktranslate-netflow-collector --restart unless-stopped --pull=always --net=host \
-v `pwd`/snmp-base.yaml:/snmp-base.yaml \
-e NEW_RELIC_API_KEY=$NET_SIM_LICENSE \
kentik/ktranslate:v2 \
  -snmp /snmp-base.yaml \
  -nr_account_id=$NET_SIM_ACCOUNT \
  -metrics=jchf \
  -tee_logs=true \
  -nf.source=auto \
  -service_name=net-sim \
  -nf.port=2055 \
  -flow_only=true \
  nr1.flow