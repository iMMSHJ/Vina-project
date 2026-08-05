#!/usr/bin/env bash
#
# Vina Business Server Installer
# Main Entry Point
#

set -Eeuo pipefail


BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


########################################
# Load Libraries
########################################

source "${BASE_DIR}/lib/colors.sh"
source "${BASE_DIR}/lib/logger.sh"
source "${BASE_DIR}/lib/functions.sh"


########################################
# Load Configuration
########################################

source "${BASE_DIR}/config/installer.conf"


########################################
# Banner
########################################

echo
echo "================================================"
echo "        Vina Business Server Installer"
echo "        Odoo ${ODOO_VERSION}"
echo "================================================"
echo


########################################
# Modules
########################################

MODULES=(
    "00-precheck.sh"
    "01-bootstrap.sh"
    "02-system-update.sh"
    "03-users.sh"
    "04-postgresql.sh"
    "05-redis.sh"
    "06-python.sh"
    "00-preflight.sh"
    "07-odoo-source.sh"
    "08-odoo-config.sh"
    "08b-odoo-db-init.sh"    # ← جدید
    "09-odoo-systemd.sh"
    "10-nginx.sh"
    "11-local-ssl.sh"
    "12-firewall.sh"
    "13-backup.sh"
    "14-security.sh"
    "15-logrotate.sh"
    "17-oca-install.sh"
    "18-addon-path.sh"
    "16-healthcheck.sh"
)

# NOTE: 00-preflight.sh runs right after 06-python.sh (not at the
# start, despite its "00" prefix) because it checks for build-essential
# / python3.12-dev / libpq-dev / etc., which aren't installed until
# 06-python.sh runs. Its filename kept the "00" prefix for git history
# reasons; only its position in this list determines execution order.
#
# NOTE: 16-healthcheck.sh was moved to run AFTER 17/18 (OCA + addons
# path) instead of at position 16, since it's a read-only check and
# makes more sense as the final step once everything is configured.


########################################
# Run Modules
########################################

for module in "${MODULES[@]}"
do

    MODULE_PATH="${BASE_DIR}/modules/${module}"

    if [[ -f "$MODULE_PATH" ]]; then

        info "Running ${module}"

        bash "$MODULE_PATH"

    else

        warning "${module} not found, skipping"

    fi

done

STATE_FILE="/var/log/odoo-install.state"
[[ -f "$STATE_FILE" ]] && source "$STATE_FILE"

for module in "${MODULES[@]}"; do
    [[ "${COMPLETED[$module]}" == "yes" ]] && continue
    bash "$MODULE_PATH"
    echo "COMPLETED[$module]=yes" >> "$STATE_FILE"
done


success "Installer finished"
