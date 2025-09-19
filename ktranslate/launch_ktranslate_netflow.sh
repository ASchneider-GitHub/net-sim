#!/usr/bin/env bash

if [[ -z "$NET_SIM_LICENSE" ]]; then
  echo "Env var NET_SIM_LICENSE is not set"
  exit 1
fi

if [[ -z "$NET_SIM_ACCOUNT" ]]; then
  echo "Env var NET_SIM_ACCOUNT is not set"
  exit 1
fi

echo "Launching netflow container"

# If you change the container name, you also need to update it in scripts/netflow_generator.sh
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
