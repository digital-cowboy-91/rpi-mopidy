#!/bin/bash

set -e

LOG="/var/log/rpi-mopidy/mopidy-config.log"
mkdir -p /var/log/rpi-mopidy
echo "[$(date)] mopidy/install-config.sh starting" >> "$LOG"

CONF_DIR="/etc/mopidy"
CONF_FILE="$CONF_DIR/mopidy.conf"

sudo mkdir -p "$CONF_DIR"

if [ ! -f "$CONF_FILE" ]; then
    sudo cp "$(dirname "$0")/mopidy.conf.example" "$CONF_FILE"
fi

echo "[$(date)] mopidy/install-config.sh completed" >> "$LOG"
