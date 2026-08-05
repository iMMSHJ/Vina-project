#!/bin/bash
# installer/modules/14-security-jails.sh
# Configures Fail2ban jails for SSH and Nginx (Vina / odoo-installer)

set -e

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/config/installer.conf"

echo "========================================"
echo " Fail2ban Jails Configuration"
echo "========================================"

if [ "${FAIL2BAN_ENABLE}" != "yes" ]; then
    echo "[SKIP] FAIL2BAN_ENABLE is not 'yes', skipping jail setup"
    exit 0
fi

# Fallback defaults if not defined in installer.conf
FAIL2BAN_BANTIME="${FAIL2BAN_BANTIME:-3600}"
FAIL2BAN_FINDTIME="${FAIL2BAN_FINDTIME:-600}"
FAIL2BAN_MAXRETRY="${FAIL2BAN_MAXRETRY:-5}"
FAIL2BAN_IGNOREIP="${FAIL2BAN_IGNOREIP:-127.0.0.1/8 ::1}"

# Ensure fail2ban is installed (safety check, should already be done in 14-security.sh)
if ! command -v fail2ban-client &>/dev/null; then
    echo "[ERROR] fail2ban is not installed. Run 14-security.sh first."
    exit 1
fi

echo "[INFO] Creating /etc/fail2ban/jail.local..."

cat > /etc/fail2ban/jail.local <<EOF
[DEFAULT]
bantime  = ${FAIL2BAN_BANTIME}
findtime = ${FAIL2BAN_FINDTIME}
maxretry = ${FAIL2BAN_MAXRETRY}
ignoreip = ${FAIL2BAN_IGNOREIP}

[sshd]
enabled  = true
port     = 22
logpath  = /var/log/auth.log
maxretry = 5

[nginx-http-auth]
enabled  = true
port     = http,https
logpath  = /var/log/nginx/error.log

[nginx-limit-req]
enabled  = true
port     = http,https
logpath  = /var/log/nginx/error.log

[nginx-bad-request]
enabled  = true
port     = http,https
logpath  = /var/log/nginx/access.log
maxretry = 3
EOF

echo "[INFO] Validating Fail2ban configuration..."
fail2ban-client --test || { echo "[ERROR] Config test failed"; exit 1; }

echo "[INFO] Restarting Fail2ban..."
systemctl restart fail2ban
systemctl enable fail2ban --now

echo "[INFO] Active jails:"
fail2ban-client status

echo "[OK] Fail2ban jails configured"
