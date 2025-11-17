#!/bin/bash
set -e

echo "========================================"
echo "         RPI Mopidy — Install"
echo "========================================"

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[*] Updating apt..."
apt-get update -y

echo "[*] Installing dependencies..."
apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
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

echo "[*] Installing Python packages..."
pip3 install --break-system-packages \
    mopidy==3.* \
    Mopidy-ALSAMixer

mkdir -p /var/log/rpi-mopidy
chmod 755 /var/log/rpi-mopidy

echo "[*] Installing mopidy..."
bash "$REPO_DIR/mopidy/setup.sh"

echo "========================================"
echo " Installation complete!"
echo "========================================"
echo ""
echo "⚠️  A reboot is recommended before using Mopidy."
echo "Run: sudo reboot"
