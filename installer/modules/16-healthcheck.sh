#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/config/installer.conf"

echo "========================================"
echo " Odoo Business Server Health Check"
echo "========================================"

echo

check_service() {
    if systemctl is-active --quiet "$1"; then
        echo "[OK] $1 is running"
    else
        echo "[FAIL] $1 is NOT running"
    fi
}

echo "[1] Services"
check_service postgresql
check_service odoo

if [ "${NGINX_ENABLE}" = "yes" ]; then
    check_service nginx
else
    echo "[SKIP] nginx disabled in installer.conf"
fi

if [ "${FAIL2BAN_ENABLE}" = "yes" ]; then
    check_service fail2ban
else
    echo "[SKIP] fail2ban disabled in installer.conf"
fi

echo

echo "[2] Ports"

if ss -tulpn | grep -q ":8069"; then
    echo "[OK] Odoo port 8069 listening"
else
    echo "[FAIL] Odoo port 8069 closed"
fi


if [ "${NGINX_ENABLE}" = "yes" ]; then

    if ss -tulpn | grep -q ":80"; then
        echo "[OK] HTTP port 80 listening"
    else
        echo "[FAIL] HTTP port 80 closed"
    fi


    if [ "${SSL_ENABLE}" = "yes" ]; then
        if ss -tulpn | grep -q ":443"; then
            echo "[OK] HTTPS port 443 listening"
        else
            echo "[WARN] HTTPS port 443 not listening"
        fi
    fi

else
    echo "[SKIP] HTTP/HTTPS port checks (nginx disabled in installer.conf)"
fi


echo

echo "[3] Odoo HTTP Check"

if [ "${NGINX_ENABLE}" = "yes" ] && [ "${SSL_ENABLE}" = "yes" ]; then
    if curl -k -s "https://${ODOO_DOMAIN}" | grep -q "Redirecting"; then
        echo "[OK] Odoo HTTPS response"
    else
        echo "[WARN] Odoo HTTPS check failed"
    fi
else
    echo "[SKIP] HTTPS check (nginx or SSL disabled in installer.conf)"
fi


echo

echo "[4] Disk"

df -h / | tail -1


echo

echo "[5] Backup"

if [ "${BACKUP_ENABLE}" = "yes" ]; then
    if ls /opt/odoo/backup/postgres/*.gz >/dev/null 2>&1; then
        echo "[OK] PostgreSQL backup exists"
    else
        echo "[FAIL] No PostgreSQL backup found"
    fi
else
    echo "[SKIP] Backup disabled in installer.conf"
fi


echo

echo "========================================"
echo " Health Check Finished"
echo "========================================"
