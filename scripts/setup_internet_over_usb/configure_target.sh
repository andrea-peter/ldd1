#!/bin/bash

PASSWORD=temppwd
USER=debian

function usage() {
  echo >&2 "Usage: $0 HOST_IP TARGET_IP"
}

function sudo_ssh_cmd() {
  sshpass "-p${PASSWORD}" ssh "${USER}@${TARGET_IP}" "echo ${PASSWORD} | sudo -S bash -c \"$*\""
}

# Get arguments
if [ $# -ne 2 ]; then
  usage
  exit 1
fi

HOST_IP=$1
TARGET_IP=$2

# Add DNS server
cmd=$(
  cat <<EOF
cat <<_EOF_ > /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
_EOF_
EOF
)
sudo_ssh_cmd "${cmd}"

# Set default gateway
sudo_ssh_cmd "route add default gw ${HOST_IP}"
