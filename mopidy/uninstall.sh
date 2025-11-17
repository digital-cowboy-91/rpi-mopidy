#!/bin/bash

set -e

LOG="/var/log/rpi-mopidy/mopidy-uninstall.log"
mkdir -p /var/log/rpi-mopidy
echo "[$(date)] mopidy/uninstall.sh starting" >> "$LOG"

# Stop & disable service
sudo systemctl stop mopidy-init.service 2>/dev/null || true
sudo systemctl disable mopidy-init.service 2>/dev/null || true

# Remove service file
sudo rm -f /etc/systemd/system/mopidy-init.service
sudo systemctl daemon-reload

# Remove installed script
sudo rm -f /usr/local/bin/mopidy-init.sh

echo "[$(date)] mopidy/uninstall.sh completed" >> "$LOG"