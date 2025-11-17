#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SOURCE="$SCRIPT_DIR/mopidy.conf"
SERVICE_SOURCE="$SCRIPT_DIR/mopidy.service"
CONFIG_PATH="/etc/mopidy/mopidy.conf"
SERVICE_PATH="/etc/systemd/system/mopidy.service"
SERVICE_NAME="mopidy"
VENV_PATH="/opt/mopidy-venv"
MOPIDY_USER="mopidy"
MOPIDY_GROUP="$MOPIDY_USER"
MOPIDY_HOME="/home/mopidy"

if [[ ! -f "$CONFIG_SOURCE" || ! -f "$SERVICE_SOURCE" ]]; then
    echo "Required files mopidy.conf or mopidy.service are missing next to install.sh" >&2
    exit 1
fi

if systemctl list-unit-files | grep -q "^${SERVICE_NAME}.service"; then
    echo "Stopping existing ${SERVICE_NAME} service..."
    systemctl stop "${SERVICE_NAME}" 2>/dev/null || true
    echo "Disabling existing ${SERVICE_NAME} service..."
    systemctl disable "${SERVICE_NAME}" 2>/dev/null || true
    systemctl reset-failed "${SERVICE_NAME}" 2>/dev/null || true
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

if [[ -d "$VENV_PATH" ]]; then
    echo "Existing Mopidy virtual environment found at ${VENV_PATH}, removing..."
    rm -rf "$VENV_PATH"
fi

echo "Creating Mopidy virtual environment at ${VENV_PATH} (with system site packages)..."
python3 -m venv --system-site-packages "$VENV_PATH"

echo "Installing Mopidy inside venv..."
"$VENV_PATH/bin/pip" install --upgrade pip
"$VENV_PATH/bin/pip" install \
    --ignore-installed \
    mopidy==3.* \
    Mopidy-ALSAMixer \
    Mopidy-TuneIn \
    PyGObject

echo "Applying Mopidy GStreamer mime workaround..."
SCAN_FILE="$("$VENV_PATH/bin/python3" - <<'PY'
import inspect
import mopidy.audio.scan as scan
import os
print(os.path.abspath(inspect.getfile(scan)))
PY
)"
if [[ -n "$SCAN_FILE" && -f "$SCAN_FILE" ]]; then
    "$VENV_PATH/bin/python3" - "$SCAN_FILE" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
needle = 'mime = msg.get_structure().get_value("caps").get_name()'
replacement = '    mime = None  # Mopidy Trixie GStreamer workaround'
text = path.read_text()
if needle in text and replacement not in text:
    text = text.replace(needle, replacement, 1)
    path.write_text(text)
PY
else
    echo "Warning: unable to locate mopidy.audio.scan for patching" >&2
fi

if [[ ! -x "$VENV_PATH/bin/mopidy" ]]; then
    echo "Mopidy executable missing from ${VENV_PATH}/bin. Installation failed." >&2
    exit 1
fi

echo "Creating Mopidy config directory..."
mkdir -p /etc/mopidy

echo "Installing Mopidy config to /etc/mopidy/mopidy.conf..."
install -m 644 "$CONFIG_SOURCE" "$CONFIG_PATH"

echo "Ensuring mopidy user exists and has a writable home..."
if id "$MOPIDY_USER" &>/dev/null; then
    current_home="$(getent passwd "$MOPIDY_USER" | cut -d: -f6)"
    if [[ "$current_home" != "$MOPIDY_HOME" && -n "$current_home" ]]; then
        usermod -d "$MOPIDY_HOME" "$MOPIDY_USER"
    fi
else
    useradd -r -m -d "$MOPIDY_HOME" -s /bin/false "$MOPIDY_USER"
fi
mkdir -p "$MOPIDY_HOME"
chown -R "$MOPIDY_USER:$MOPIDY_GROUP" "$MOPIDY_HOME"
chown -R "$MOPIDY_USER:$MOPIDY_GROUP" /etc/mopidy

echo "Installing systemd service to /etc/systemd/system/mopidy.service..."
install -m 644 "$SERVICE_SOURCE" "$SERVICE_PATH"

echo "Fixing permissions..."
chown -R "$MOPIDY_USER:$MOPIDY_GROUP" "$VENV_PATH"

echo "Reloading systemd..."
systemctl daemon-reload

echo "Enabling Mopidy service..."
systemctl enable "$SERVICE_NAME"

echo "Starting Mopidy service..."
systemctl start "$SERVICE_NAME"

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
