#!/bin/bash

set -e

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/config/installer.conf"

echo "========================================"
echo " Local SSL Certificate"
echo "========================================"

if [ "${SSL_ENABLE}" != "yes" ]; then
    echo "[SKIP] SSL_ENABLE is not 'yes' in installer.conf, skipping SSL setup"
    exit 0
fi

DOMAIN="${ODOO_DOMAIN}"

SSL_DIR="/etc/nginx/ssl"


apt install -y openssl


mkdir -p $SSL_DIR


if [ ! -f "$SSL_DIR/localCA.crt" ]; then

echo "[INFO] Creating local CA"

openssl genrsa \
-out $SSL_DIR/localCA.key 4096


openssl req \
-new \
-key $SSL_DIR/$DOMAIN.key \
-out $SSL_DIR/$DOMAIN.csr \
-subj "/C=${SSL_COUNTRY}/O=Vina Group/CN=$DOMAIN"


fi


echo "[INFO] Creating server certificate"


openssl genrsa \
-out $SSL_DIR/$DOMAIN.key 2048


openssl req \
-new \
-key $SSL_DIR/$DOMAIN.key \
-out $SSL_DIR/$DOMAIN.csr \
-subj "/C=DE/O=Vina Group/CN=$DOMAIN"


cat > $SSL_DIR/ext.cnf <<EOF
subjectAltName=DNS:$DOMAIN
EOF


openssl x509 \
-req \
-in $SSL_DIR/$DOMAIN.csr \
-CA $SSL_DIR/localCA.crt \
-CAkey $SSL_DIR/localCA.key \
-CAcreateserial \
-out $SSL_DIR/$DOMAIN.crt \
-days 825 \
-sha256 \
-extfile $SSL_DIR/ext.cnf



echo "[INFO] Updating nginx SSL config"


cat > /etc/nginx/sites-available/odoo <<EOF

server {

listen 80;
server_name $DOMAIN;

return 301 https://\$host\$request_uri;

}


server {

listen 443 ssl;
server_name $DOMAIN;


ssl_certificate $SSL_DIR/$DOMAIN.crt;
ssl_certificate_key $SSL_DIR/$DOMAIN.key;


proxy_read_timeout 720s;
proxy_connect_timeout 720s;
proxy_send_timeout 720s;


location /websocket {

proxy_pass http://127.0.0.1:8072;

proxy_set_header Host \$host;
proxy_set_header X-Real-IP \$remote_addr;
proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto https;

proxy_http_version 1.1;
proxy_set_header Upgrade \$http_upgrade;
proxy_set_header Connection "upgrade";

}

location / {

proxy_pass http://127.0.0.1:8069;

proxy_set_header Host \$host;
proxy_set_header X-Real-IP \$remote_addr;
proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto https;

}

}

EOF


chmod 600 $SSL_DIR/*.key


nginx -t

systemctl restart nginx


echo "[OK] SSL enabled for $DOMAIN"
