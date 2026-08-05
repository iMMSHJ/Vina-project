#!/bin/bash
set -e

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/config/installer.conf"

echo "========================================"
echo " Odoo Configuration"
echo "========================================"

ODOO_HOME="/opt/odoo"
ODOO_CONF="/etc/odoo"

echo "[INFO] Creating directories..."

mkdir -p \
$ODOO_HOME/data \
$ODOO_HOME/logs \
$ODOO_HOME/custom_addons \
$ODOO_HOME/oca \
$ODOO_CONF


echo "[INFO] Creating environment file..."

cat > $ODOO_CONF/odoo.env <<EOF
ODOO_DB_USER=odoo
EOF


########################################
# Odoo Master (admin) Password
########################################
#
# Prompted interactively and written once into odoo.conf. It is NOT
# kept anywhere else (no env file, no log, no installer state). Odoo
# itself hashes this value in place inside odoo.conf the first time
# the master-password-protected database-manager screen is used, so
# it does not stay in plaintext for long after the server starts.

echo "[INFO] Setting Odoo master password..."

while true; do

    read -rs -p "Enter Odoo master (admin) password: " ODOO_ADMIN_PASS
    echo
    read -rs -p "Confirm password: " ODOO_ADMIN_PASS_CONFIRM
    echo

    if [ -z "$ODOO_ADMIN_PASS" ]; then
        echo "[WARN] Password cannot be empty, try again"
        continue
    fi

    if [ "$ODOO_ADMIN_PASS" != "$ODOO_ADMIN_PASS_CONFIRM" ]; then
        echo "[WARN] Passwords did not match, try again"
        continue
    fi

    break

done


echo "[INFO] Creating Odoo config..."

########################################
# Worker / performance sizing
########################################
#
# Standard Odoo sizing formula: workers = (cpu_cores * 2) + 1, with
# one worker reserved as a cron worker. Below 2 cores, multi-worker
# mode isn't worth the overhead, so we fall back to workers = 0
# (single-process, dev-style, fine for a small/low-traffic VPS).

CPU_CORES=$(nproc)

if [ "${CPU_CORES}" -ge 2 ]; then
    WORKERS=$(( (CPU_CORES * 2) + 1 ))
    MAX_CRON_THREADS=2
else
    WORKERS=0
    MAX_CRON_THREADS=1
fi

echo "[INFO] Detected ${CPU_CORES} CPU core(s) -> workers=${WORKERS}"

DEV_MODE_LINE=""
if [ "${ODOO_DEV_MODE}" = "yes" ]; then
    DEV_MODE_LINE="dev_mode = reload,qweb,xml"
fi

cat > $ODOO_CONF/odoo.conf <<EOF
[options]

admin_passwd = ${ODOO_ADMIN_PASS}

; Odoo connects to PostgreSQL over the local Unix socket using
; "peer" authentication (the odoo Linux user maps to the odoo
; PostgreSQL role), so no database password is needed or stored here.
db_host = False
db_port = 5432
db_user = odoo
db_password = False

addons_path = /opt/odoo/src/odoo/odoo/addons,/opt/odoo/custom_addons,/opt/odoo/oca

data_dir = /opt/odoo/data

logfile = /opt/odoo/logs/odoo.log

http_port = 8069
http_interface = 0.0.0.0

proxy_mode = True

; Performance (sized for ${CPU_CORES} CPU core(s))
workers = ${WORKERS}
max_cron_threads = ${MAX_CRON_THREADS}
limit_memory_hard = 2684354560
limit_memory_soft = 2147483648
limit_time_cpu = 600
limit_time_real = 1200
limit_request = 8192

${DEV_MODE_LINE}
EOF

unset ODOO_ADMIN_PASS ODOO_ADMIN_PASS_CONFIRM


echo "[INFO] Setting permissions..."

chown -R odoo:odoo /opt/odoo
chown -R odoo:odoo /etc/odoo

chmod 640 /etc/odoo/odoo.conf
chmod 640 /etc/odoo/odoo.env


echo "[OK] Odoo configuration completed"
