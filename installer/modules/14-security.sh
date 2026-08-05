#!/bin/bash

set -e

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/config/installer.conf"

echo "========================================"
echo " Security Hardening"
echo "========================================"

if [ "${FAIL2BAN_ENABLE}" != "yes" ]; then
    echo "[SKIP] FAIL2BAN_ENABLE is not 'yes' in installer.conf, skipping fail2ban setup"
    exit 0
fi

apt update
apt install -y fail2ban

systemctl enable fail2ban
systemctl restart fail2ban

echo "[OK] Fail2ban installed"
