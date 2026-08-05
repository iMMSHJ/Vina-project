#!/usr/bin/env bash
#
# Vina Business Server Installer
# Main Entry Point
#

set -Eeuo pipefail


########################################
# Base Directory
########################################

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

CONFIG_FILE="${BASE_DIR}/config/installer.conf"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "ERROR: Configuration file not found: $CONFIG_FILE" >&2
    exit 1
fi

source "$CONFIG_FILE"


########################################
# State and Lock
########################################

STATE_FILE="/var/log/odoo-install.state"
LOCK_FILE="/var/lock/odoo-installer.lock"

STATE_DIR="$(dirname "$STATE_FILE")"
LOCK_DIR="$(dirname "$LOCK_FILE")"

if [[ ! -d "$STATE_DIR" ]]; then
    mkdir -p "$STATE_DIR"
fi

if [[ ! -d "$LOCK_DIR" ]]; then
    mkdir -p "$LOCK_DIR"
fi

# Prevent concurrent installer executions.
exec 9>"$LOCK_FILE"

if ! flock -n 9; then
    error "Another installer process is already running"
    exit 1
fi


########################################
# Completed Modules
########################################

declare -A COMPLETED=()


########################################
# Load State File
########################################

load_state() {
    local module
    local status

    [[ -f "$STATE_FILE" ]] || return 0

    while IFS='=' read -r module status; do
        [[ -n "$module" ]] || continue
        [[ "$status" == "yes" ]] || continue

        # Accept only modules defined in MODULES.
        for known_module in "${MODULES[@]}"; do
            if [[ "$module" == "$known_module" ]]; then
                COMPLETED["$module"]="yes"
                break
            fi
        done
    done < "$STATE_FILE"
}


########################################
# Save Module State
########################################

mark_completed() {
    local module="$1"
    local tmp_state

    COMPLETED["$module"]="yes"

    tmp_state="${STATE_FILE}.tmp"

    {
        for completed_module in "${!COMPLETED[@]}"; do
            if [[ "${COMPLETED[$completed_module]}" == "yes" ]]; then
                printf '%s=yes\n' "$completed_module"
            fi
        done
    } | sort > "$tmp_state"

    mv -f "$tmp_state" "$STATE_FILE"
}


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
    "08b-odoo-db-init.sh"
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


########################################
# Load Existing State
########################################

load_state


########################################
# Run Modules
########################################

for module in "${MODULES[@]}"; do

    MODULE_PATH="${BASE_DIR}/modules/${module}"

    if [[ "${COMPLETED[$module]:-no}" == "yes" ]]; then
        info "Skipping ${module}; already completed"
        continue
    fi

    if [[ ! -f "$MODULE_PATH" ]]; then
        warning "${module} not found, skipping"
        continue
    fi

    if [[ ! -r "$MODULE_PATH" ]]; then
        error "Module is not readable: $MODULE_PATH"
        exit 1
    fi

    info "Running ${module}"

    if bash "$MODULE_PATH"; then
        mark_completed "$module"
        success "${module} completed"
    else
        error "${module} failed"
        exit 1
    fi

done


########################################
# Finish
########################################

success "Installer finished"
