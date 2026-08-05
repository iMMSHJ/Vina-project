#!/bin/bash

set -e

echo "========================================"
echo " Odoo Systemd Service"
echo "========================================"

echo "[INFO] Creating systemd service..."

sudo tee /etc/systemd/system/odoo.service > /dev/null <<EOF
[Unit]
Description=Odoo 19 Business ERP
After=network.target postgresql.service
Requires=postgresql.service

[Service]
Type=simple

User=odoo
Group=odoo

WorkingDirectory=/opt/odoo/src/odoo

EnvironmentFile=/etc/odoo/odoo.env

ExecStart=/opt/odoo/venv/bin/python \
/opt/odoo/src/odoo/odoo-bin \
-c /etc/odoo/odoo.conf

Restart=always
RestartSec=5

TimeoutStartSec=300
TimeoutStopSec=60

LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF


echo "[INFO] Reload systemd..."

sudo systemctl daemon-reload


echo "[INFO] Enable Odoo service..."

sudo systemctl enable odoo


echo "[OK] Odoo systemd service created"
