#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"

function usage() {
  echo >&2 "Usage: $0 HOST_USB_IF HOST_WIFI_IF"
  echo >&2 "With:"
  echo >&2 "  HOST_USB_IF:  Name of the host USB interface connected to the target"
  echo >&2 "  HOST_WIFI_IF: Name of the host Wifi or Ethernet interface"
}

if [ $# -ne 2 ]; then
  usage
  exit 1
fi

HOST_USB_IF=$1
HOST_WIFI_IF=$2

# Get host IP from interface
HOST_IP=$(ip -f inet address show dev "${HOST_USB_IF}" | sed -En 's/\s+inet ([0-9.]+).+/\1/p')

# Get target IP from host IP, basically replace trailing 1 with 2
TARGET_IP="${HOST_IP%%1}2"

# Configure host
"${SCRIPT_DIR}/configure_host.sh" "${HOST_USB_IF}" "${HOST_WIFI_IF}" "${TARGET_IP}"

# Configure target
"${SCRIPT_DIR}/configure_target.sh" "${HOST_IP}" "${TARGET_IP}"
