#!/bin/bash

set -e

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/config/installer.conf"

echo "========================================"
echo " Firewall & Security"
echo "========================================"

if [ "${FIREWALL_ENABLE}" != "yes" ]; then
    echo "[SKIP] FIREWALL_ENABLE is not 'yes' in installer.conf, skipping firewall setup"
    exit 0
fi

echo "[INFO] Installing UFW..."

apt update
apt install -y ufw


echo "[INFO] Reset firewall..."

# Only reset on the very first run (UFW not active yet). Re-running
# the installer later must NOT wipe out any custom rules an admin
# added after the initial install.
if ! ufw status | grep -q "Status: active"; then
    echo "[INFO] UFW not active yet, resetting to a clean baseline"
    ufw --force reset
else
    echo "[SKIP] UFW already active, leaving existing rules in place"
fi


echo "[INFO] Default policies..."

ufw default deny incoming
ufw default allow outgoing


echo "[INFO] Allow SSH..."

ufw allow 22/tcp


echo "[INFO] Allow HTTP..."

ufw allow 80/tcp


echo "[INFO] Allow HTTPS..."

ufw allow 443/tcp


echo "[INFO] Enable firewall..."

ufw --force enable


echo "[OK] Firewall configured"


ufw status verbose
