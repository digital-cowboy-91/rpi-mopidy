#!/bin/bash

set -e

LOG="/var/log/rpi-mopidy/mopidy-setup.log"
mkdir -p /var/log/rpi-mopidy
echo "[$(date)] mopidy/setup.sh starting" >> "$LOG"

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

id -u mopidy &>/dev/null || sudo useradd -r -s /usr/sbin/nologin -G audio mopidy

"$REPO_DIR/install-config.sh"

sudo install -m 755 "$REPO_DIR/mopidy-init.sh" /usr/local/bin/mopidy-init.sh
sudo install -m 644 "$REPO_DIR/mopidy-init.service" /etc/systemd/system/mopidy-init.service

sudo systemctl daemon-reload
sudo systemctl enable mopidy-init.service

echo "[$(date)] mopidy/setup.sh completed" >> "$LOG"