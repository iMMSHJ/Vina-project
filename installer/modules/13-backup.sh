#!/bin/bash

set -e

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/config/installer.conf"

echo "========================================"
echo " Odoo Backup System"
echo "========================================"

if [ "${BACKUP_ENABLE}" != "yes" ]; then
    echo "[SKIP] BACKUP_ENABLE is not 'yes' in installer.conf, skipping backup setup"
    exit 0
fi


BACKUP_DIR="/opt/odoo/backup"
DB_USER="odoo"

echo "[INFO] Creating backup directories..."

mkdir -p $BACKUP_DIR/postgres
mkdir -p $BACKUP_DIR/filestore
mkdir -p $BACKUP_DIR/scripts


########################################
# Standalone backup script (used by cron)
########################################
#
# The actual backup logic lives in its own script so it can be run
# on a schedule, not just once during install.

cat > $BACKUP_DIR/scripts/run-backup.sh <<'EOF'
#!/bin/bash
set -e

BACKUP_DIR="/opt/odoo/backup"
DATE=$(date +%Y-%m-%d_%H-%M)

echo "[INFO] PostgreSQL backup..."

sudo -u postgres pg_dumpall \
| gzip > $BACKUP_DIR/postgres/postgres-$DATE.sql.gz


echo "[INFO] Odoo filestore backup..."

if [ -d "/opt/odoo/data/filestore" ]; then

tar -czf \
$BACKUP_DIR/filestore/filestore-$DATE.tar.gz \
-C /opt/odoo/data \
filestore

else

echo "[WARN] No filestore found yet"

fi


echo "[INFO] Cleaning old backups..."

find $BACKUP_DIR/postgres \
-type f \
-name "*.gz" \
-mtime +30 \
-delete

find $BACKUP_DIR/filestore \
-type f \
-name "*.gz" \
-mtime +30 \
-delete

chown -R odoo:odoo /opt/odoo/backup

echo "[OK] Backup completed"
EOF

chmod 750 $BACKUP_DIR/scripts/run-backup.sh
chown root:odoo $BACKUP_DIR/scripts/run-backup.sh


########################################
# Scheduled backup (cron)
########################################

CRON_FILE="/etc/cron.d/odoo-backup"

echo "[INFO] Installing cron schedule (${BACKUP_CRON_SCHEDULE})..."

cat > $CRON_FILE <<EOF
${BACKUP_CRON_SCHEDULE} root $BACKUP_DIR/scripts/run-backup.sh >> /opt/odoo/logs/backup.log 2>&1
EOF

chmod 644 $CRON_FILE


########################################
# Run an initial backup now, to prove it works
########################################

echo "[INFO] Running initial backup..."

bash $BACKUP_DIR/scripts/run-backup.sh


ls -lh $BACKUP_DIR/postgres
ls -lh $BACKUP_DIR/filestore
