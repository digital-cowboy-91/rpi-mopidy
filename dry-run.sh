#!/bin/bash
set -e

echo "========================================"
echo "       RPI Mopidy — Dry Run Check"
echo "========================================"
echo

echo "1) Checking global scripts..."
echo "----------------------------------------"
for f in install.sh uninstall.sh post-install-check.sh; do
  if [ -f "$f" ]; then
    echo "[ OK ] Found: $f"
  else
    echo "[FAIL] Missing: $f"
  fi
done
echo

echo "2) Checking mopidy module..."
echo "----------------------------------------"
FILES=(
  mopidy/setup.sh
  mopidy/uninstall.sh
  mopidy/mopidy-init.sh
  mopidy/mopidy-init.service
  mopidy/mopidy.conf.example
  mopidy/install-config.sh
)

for file in "${FILES[@]}"; do
  if [ -f "$file" ]; then
    echo "[ OK ] Found: $file"
  else
    echo "[FAIL] Missing: $file"
  fi
done
echo

echo "3) Checking install.sh for dependency sections..."
echo "----------------------------------------"
grep -q "Installing dependencies" install.sh && echo "[ OK ] Found apt dependency block" || echo "[FAIL] Missing apt dependency block"
grep -q "Installing Python packages" install.sh && echo "[ OK ] Found pip dependency block" || echo "[FAIL] Missing pip dependency block"

echo "Dry run completed."
