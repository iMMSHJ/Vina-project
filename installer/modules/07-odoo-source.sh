#!/usr/bin/env bash
#
# Vina Business Server Installer
# Module: 07-odoo-source
#

set -Eeuo pipefail


BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "${BASE_DIR}/lib/colors.sh"
source "${BASE_DIR}/lib/functions.sh"
source "${BASE_DIR}/config/installer.conf"


echo
echo "========================================"
echo " Odoo 19 Source Installation"
echo "========================================"
echo



########################################
# Create Directories
########################################

info "Creating Odoo directories..."

mkdir -p \
"${ODOO_HOME}/src" \
"${ODOO_CUSTOM_ADDONS}" \
"${ODOO_OCA}" \
"${ODOO_HOME}/data" \
"${ODOO_HOME}/logs" \
"${ODOO_HOME}/backup"


########################################
# Clone Odoo Source
########################################

if [ ! -d "${ODOO_SOURCE}/.git" ]; then

    info "Cloning Odoo ${ODOO_VERSION} source..."

    git clone \
	--depth 1 \
	--branch "${ODOO_BRANCH}" \
	"${ODOO_REPO}" \
	"${ODOO_SOURCE}"
else

    info "Odoo source already exists"

fi


########################################
# Verify Version
########################################

if [ -f "${ODOO_SOURCE}/odoo/release.py" ]; then

    success "Odoo source downloaded"

else

    error "Odoo source validation failed"

fi


########################################
# Install Odoo Requirements
########################################

if [ -f "${ODOO_SOURCE}/requirements.txt" ]; then

    info "Installing Odoo Python requirements..."

    "${ODOO_VENV}/bin/pip" install \
        -r "${ODOO_SOURCE}/requirements.txt"

else

    warning "requirements.txt not found"

fi


########################################
# Permissions
########################################

info "Setting permissions..."

chown -R \
"${ODOO_USER}:${ODOO_GROUP}" \
"${ODOO_HOME}"


success "Odoo source setup completed"
