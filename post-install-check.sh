#!/bin/bash
set -e

echo "========================================"
echo "     RPI Mopidy — Post Install Check"
echo "========================================"
echo

echo "1) Checking service status..."
systemctl is-enabled mopidy-init.service >/dev/null 2>&1 && \
  echo "[ OK ] mopidy-init.service is enabled" || \
  echo "[FAIL] mopidy-init.service is NOT enabled"
echo

echo "2) Checking Mopidy binary..."
if command -v mopidy >/dev/null 2>&1; then
  echo "[ OK ] Mopidy binary found"
else
  echo "[FAIL] Mopidy binary missing"
fi
echo

echo "3) Checking configuration..."
if [ -f /etc/mopidy/mopidy.conf ]; then
  echo "[ OK ] /etc/mopidy/mopidy.conf exists"
else
  echo "[FAIL] Config file missing"
fi

echo
echo "Post-install check complete."
