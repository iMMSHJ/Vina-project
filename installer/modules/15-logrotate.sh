#!/bin/bash

set -e

echo "========================================"
echo " Odoo Logrotate"
echo "========================================"

echo "[INFO] Creating logrotate config..."

cat > /etc/logrotate.d/odoo <<'EOF'
/opt/odoo/logs/*.log {
    daily
    rotate 14
    size 50M
    missingok
    notifempty
    compress
    delaycompress
    copytruncate
    create 0640 odoo odoo
}
EOF

echo "[INFO] Testing logrotate..."

logrotate -d /etc/logrotate.d/odoo > /dev/null

echo "[OK] Odoo logrotate configured"
