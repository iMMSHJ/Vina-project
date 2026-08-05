#!/bin/bash

set -e

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/config/installer.conf"

echo "========================================"
echo " Nginx Reverse Proxy"
echo "========================================"

if [ "${NGINX_ENABLE}" != "yes" ]; then
    echo "[SKIP] NGINX_ENABLE is not 'yes' in installer.conf, skipping nginx setup"
    exit 0
fi

DOMAIN="${ODOO_DOMAIN}"

echo "[INFO] Installing nginx..."

apt update
apt install -y nginx


echo "[INFO] Creating nginx config..."

cat > /etc/nginx/sites-available/odoo <<EOF
server {

    listen 80;
    server_name $DOMAIN;

    location /websocket {

        proxy_pass http://127.0.0.1:8072;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";

    }

    location / {

        proxy_pass http://127.0.0.1:8069;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

    }

}
EOF


echo "[INFO] Removing old configs..."

rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-enabled/odoo.conf


echo "[INFO] Enabling Odoo site..."

ln -sf /etc/nginx/sites-available/odoo \
/etc/nginx/sites-enabled/odoo


echo "[INFO] Testing nginx..."

nginx -t


systemctl enable nginx
systemctl restart nginx


echo "[OK] Nginx configured"
