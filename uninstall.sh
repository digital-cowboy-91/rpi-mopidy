#!/bin/bash
set -e

echo "========================================"
echo "       RPI Mopidy — Uninstall"
echo "========================================"

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[*] Uninstalling mopidy..."
bash "$REPO_DIR/mopidy/uninstall.sh"

echo "========================================"
echo " Uninstall complete!"
echo "========================================"
echo ""
echo "⚠️  A reboot is recommended to fully finalize removal."
echo "Run: sudo reboot"
