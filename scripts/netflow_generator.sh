#!/bin/bash

TARGET="ktranslate-netflow-collector"
PORTS=(80 443 12345 2055) # Port array for flow variation
VERSION=5 # Netflow version. Can be 1|5|9|10
INTERVAL=0.1
EXPORTPORT=2055
GATEWAY=$(ip route | awk '/default/ { print $3 }')

while ! getent hosts "$TARGET" > /dev/null; do
  echo "Waiting for "$TARGET" to resolve..."
  sleep 1
done

RESOLVED_IP=$(getent hosts "$TARGET" | awk '{print $1}')
echo "$TARGET resolved to $RESOLVED_IP"

softflowd -i eth0 -v "$VERSION" -n "$RESOLVED_IP":$EXPORTPORT -t maxlife=30 -d &

while true; do
  curl --interface eth0 -s https://metric-api.newrelic.com >/dev/null
  curl --interface eth0 -s https://insights-collector.newrelic.com >/dev/null
  curl --interface eth0 -s https://log-api.newrelic.com >/dev/null
  sleep 0.1
done
