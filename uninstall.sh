#!/bin/bash
set -e

SERVICE_NAME="mopidy"
SERVICE_PATH="/etc/systemd/system/${SERVICE_NAME}.service"
CONFIG_DIR="/etc/mopidy"
USER_NAME="mopidy"
PYTHON_BIN="python3"

echo "Stopping ${SERVICE_NAME} service if running..."
systemctl stop "${SERVICE_NAME}" 2>/dev/null || true

echo "Disabling ${SERVICE_NAME} service..."
systemctl disable "${SERVICE_NAME}" 2>/dev/null || true
systemctl reset-failed "${SERVICE_NAME}" 2>/dev/null || true

if [[ -f "${SERVICE_PATH}" ]]; then
    echo "Removing systemd service file ${SERVICE_PATH}..."
    rm -f "${SERVICE_PATH}"
fi

echo "Reloading systemd daemon..."
systemctl daemon-reload

if [[ -d "${CONFIG_DIR}" ]]; then
    echo "Removing Mopidy configuration directory ${CONFIG_DIR}..."
    rm -rf "${CONFIG_DIR}"
fi

echo "Removing Mopidy Python packages..."
"$PYTHON_BIN" -m pip uninstall -y Mopidy Mopidy-ALSAMixer Mopidy-TuneIn >/dev/null 2>&1 || true

if id "${USER_NAME}" &>/dev/null; then
    echo "Removing user ${USER_NAME}..."
    userdel -r "${USER_NAME}" 2>/dev/null || true
fi

echo
echo "======================================================"
echo " Mopidy has been removed from this system."
echo "======================================================"
