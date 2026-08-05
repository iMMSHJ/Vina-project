#!/usr/bin/env bash
#
# Vina Business Server Installer
# Module: 19-database-init
#
# Creates the first Odoo database (non-interactively) and installs
# the modules listed in ODOO_INSTALL_MODULES (installer.conf). This
# can include core Odoo modules, custom modules, or any OCA modules
# already cloned into addons_path by 17-oca-install.sh / 18-addon-path.sh
# — cloning a module only makes it available; this step is what
# actually installs it into a database.

set -Eeuo pipefail


BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "${BASE_DIR}/lib/colors.sh"
source "${BASE_DIR}/lib/functions.sh"
source "${BASE_DIR}/config/installer.conf"


echo
echo "========================================"
echo " Initial Database Setup"
echo "========================================"
echo


########################################
# Skip if the database already exists
########################################

if sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='${ODOO_DB_NAME}'" | grep -q 1
then

    info "Database '${ODOO_DB_NAME}' already exists, skipping creation"
    info "To install additional modules into it later, run:"
    echo "  sudo -u ${ODOO_USER} ${ODOO_VENV}/bin/python ${ODOO_SOURCE}/odoo-bin -c /etc/odoo/odoo.conf -d ${ODOO_DB_NAME} -i <module_list> --stop-after-init"
    exit 0

fi


########################################
# Create DB + install modules
########################################

info "Creating database '${ODOO_DB_NAME}' and installing: ${ODOO_INSTALL_MODULES}"
info "This can take a few minutes depending on how many modules were requested..."

info "Stopping Odoo service for the initial import..."
systemctl stop odoo

sudo -u "${ODOO_USER}" "${ODOO_VENV}/bin/python" "${ODOO_SOURCE}/odoo-bin" \
    -c /etc/odoo/odoo.conf \
    -d "${ODOO_DB_NAME}" \
    -i "${ODOO_INSTALL_MODULES}" \
    --without-demo=all \
    --stop-after-init

info "Restarting Odoo service..."
systemctl start odoo

if systemctl is-active --quiet odoo; then
    success "Database '${ODOO_DB_NAME}' created and Odoo service is running"
else
    error "Odoo service failed to start after database initialization"
fi
