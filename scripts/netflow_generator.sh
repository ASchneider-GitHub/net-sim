#!/bin/bash

TARGET="$(ip route | awk '/default/ { print $3 }')"
PORTS=(80 443 12345 2055) # Port array for flow variation
VERSION=5 # Netflow version. Can be 1|5|9|10
INTERVAL=0.1
EXPORTPORT=2055

softflowd -i eth0 -v "$VERSION" -n 172.30.0.1:$EXPORTPORT -t maxlife=30 -d &

while true; do
  for PORT in "${PORTS[@]}"; do
    if (( RANDOM % 2 )); then
      echo "Sending TCP SYN to $TARGET:$PORT"
      hping3 -S -c 1 -p "$PORT" "$TARGET"
    else
      echo "Sending UDP to $TARGET:$PORT"
      hping3 -2 -c 1 -p "$PORT" "$TARGET"
    fi
  done
  sleep "$INTERVAL"
done