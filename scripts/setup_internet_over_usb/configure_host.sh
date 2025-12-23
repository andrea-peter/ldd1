#!/bin/bash

set -euo pipefail

function usage() {
  echo >&2 "Usage: $0 HOST_USB_IF HOST_WIFI_IF TARGET_IP"
}

# Get arguments
if [ $# -ne 3 ]; then
  usage
  exit 1
fi

HOST_USB_IF=$1
HOST_WIFI_IF=$2
TARGET_IP=$3

# Configure NAT on host
# see: https://zersh01.github.io/iptables_interactive_scheme/

# Enable masquerade on WIFI intf
sudo iptables -t nat -A POSTROUTING -o "${HOST_WIFI_IF}" -j MASQUERADE

# Allow forwarding traffic coming from target on USB interface to WIFI interface
sudo iptables -t filter -I FORWARD -i "${HOST_USB_IF}" -s "${TARGET_IP}" -o "${HOST_WIFI_IF}" -j ACCEPT

# Allow returning traffic on WIFI interface to the target on USB interface
sudo iptables -t filter -I FORWARD -i "${HOST_WIFI_IF}" -o "${HOST_USB_IF}" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Drop all other forward traffic that does not match
sudo iptables -t filter -A FORWARD -j DROP
