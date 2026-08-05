#!/usr/bin/env bash
# ==========================================
# Module: 08b-odoo-db-init.sh
# Initialize Odoo database with Core modules
# ==========================================

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"

source "${BASE_DIR}/lib/logger.sh"
source "${BASE_DIR}/lib/functions.sh"
source "${BASE_DIR}/config/installer.conf"

# Database configuration
DB_NAME="${ODOO_DB_NAME:-vina}"
DB_USER="${POSTGRES_USER}"
ODOO_BIN="${ODOO_SOURCE}/odoo-bin"
ODOO_CONF="${ODOO_HOME}/odoo.conf"

info "Initializing Odoo database: ${DB_NAME}"

# Check if database already exists
if sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw "${DB_NAME}"; then
    warning "Database ${DB_NAME} already exists, skipping initialization"
    exit 0
fi

# Create database
info "Creating database ${DB_NAME}"
sudo -u postgres createdb -O "${DB_USER}" "${DB_NAME}"

# Initialize database with Core modules
info "Installing Core modules: ${ODOO_CORE_MODULES}"
sudo -u "${ODOO_USER}" "${ODOO_VENV}/bin/python3" "${ODOO_BIN}" \
    -c "${ODOO_CONF}" \
    -d "${DB_NAME}" \
    -i "${ODOO_CORE_MODULES}" \
    --stop-after-init \
    --logfile=/tmp/odoo-init.log

if [[ $? -eq 0 ]]; then
    success "Database initialized successfully with Core modules"
else
    error "Failed to initialize database"
    cat /tmp/odoo-init.log
    exit 1
fi
