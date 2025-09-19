#!/usr/bin/env bash

if [[ -z "$NET_SIM_LICENSE" ]]; then
  echo "Env var NET_SIM_LICENSE is not set"
  exit 1
fi

if [[ -z "$NET_SIM_ACCOUNT" ]]; then
  echo "Env var NET_SIM_ACCOUNT is not set"
  exit 1
fi

echo "Launching syslog container"

# If you change the container name, you also need to update it in scripts/syslog_exporter.sh
docker run -d --name ktranslate-syslog-collector --restart unless-stopped --pull=always --net=net-sim_sim-net \
-v `pwd`/snmp-base.yaml:/snmp-base.yaml \
-e NEW_RELIC_API_KEY=$NET_SIM_LICENSE \
kentik/ktranslate:v2 \
  -snmp /snmp-base.yaml \
  -nr_account_id=$NET_SIM_ACCOUNT \
  -metrics=jchf \
  -tee_logs=true \
  -syslog.source=0.0.0.0:514 \
  -dns=local \
  -service_name=net-sim \
  nr1.syslog
