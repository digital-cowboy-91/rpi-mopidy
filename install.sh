#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SOURCE="$SCRIPT_DIR/mopidy.conf"
SERVICE_SOURCE="$SCRIPT_DIR/mopidy.service"
CONFIG_PATH="/etc/mopidy/mopidy.conf"
SERVICE_PATH="/etc/systemd/system/mopidy.service"

if [[ ! -f "$CONFIG_SOURCE" || ! -f "$SERVICE_SOURCE" ]]; then
    echo "Required files mopidy.conf or mopidy.service are missing next to install.sh" >&2
    exit 1
fi

echo "Updating system..."
apt-get update -y

echo "Installing system packages..."
apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    python3-gi \
    python3-gst-1.0 \
    gir1.2-gst-plugins-base-1.0 \
    gir1.2-gstreamer-1.0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-alsa \
    alsa-utils \
    libcairo2-dev \
    libgirepository1.0-dev \
    libasound2-dev

echo "Creating Mopidy virtual environment at /opt/mopidy-venv..."
python3 -m venv /opt/mopidy-venv

echo "Installing Mopidy inside venv..."
/opt/mopidy-venv/bin/pip install --upgrade pip
/opt/mopidy-venv/bin/pip install \
    mopidy==3.* \
    Mopidy-ALSAMixer \
    Mopidy-TuneIn

echo "Creating Mopidy config directory..."
mkdir -p /etc/mopidy

echo "Installing Mopidy config to /etc/mopidy/mopidy.conf..."
install -m 644 "$CONFIG_SOURCE" "$CONFIG_PATH"

echo "Creating mopidy user..."
id mopidy &>/dev/null || useradd -r -s /bin/false mopidy
chown -R mopidy:mopidy /etc/mopidy

echo "Installing systemd service to /etc/systemd/system/mopidy.service..."
install -m 644 "$SERVICE_SOURCE" "$SERVICE_PATH"

echo "Fixing permissions..."
chown -R mopidy:mopidy /opt/mopidy-venv

echo "Reloading systemd..."
systemctl daemon-reload

echo "Enabling Mopidy service..."
systemctl enable mopidy

echo "Starting Mopidy service..."
systemctl start mopidy

echo
echo "======================================================"
echo " Mopidy is installed in a virtual environment"
echo " Location: /opt/mopidy-venv"
echo " Config:   /etc/mopidy/mopidy.conf"
echo " Service:  systemctl status mopidy"
echo "======================================================"
echo
echo "Mopidy now starts automatically on boot."
echo "If USB audio is not card 1, update: /etc/mopidy/mopidy.conf"
