#!/bin/bash

HOST="$(ip route | awk '/default/ { print $3 }')"
EXPORTPORT=514
FACILITY=1
SEVERITIES="0 1 2 3 4 5 6 7"
HOSTNAME="syslog_sim_device"
APPNAME="syslog_sim"
VERSION=1
PROCID="syslog_sim"

while :; do
    SEV=$(echo $SEVERITIES | tr ' ' '\n' | shuf -n1)
    PRI=$((FACILITY * 8 + SEV))
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")
    MSGID="ID$((RANDOM % 1000))"
    MSG="Random log message $((RANDOM % 10000))"

    MESSAGE="<$PRI>$VERSION $TIMESTAMP $HOSTNAME $APPNAME $PROCID $MSGID - $MSG"
    echo "Sending: $MESSAGE"
    echo "$MESSAGE" | timeout 0.5 nc -u "$HOST" "$EXPORTPORT"
    sleep 0.5
done