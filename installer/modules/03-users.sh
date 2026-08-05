#!/usr/bin/env bash
#
# Vina Business Server Installer
# Module: 03-users
#

set -Eeuo pipefail


BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "${BASE_DIR}/lib/colors.sh"
source "${BASE_DIR}/lib/functions.sh"
source "${BASE_DIR}/config/installer.conf"


echo
echo "========================================"
echo " Creating Odoo User"
echo "========================================"
echo


########################################
# Group
########################################

if ! getent group "${ODOO_GROUP}" >/dev/null; then

    info "Creating group ${ODOO_GROUP}"

    groupadd "${ODOO_GROUP}"

else

    info "Group ${ODOO_GROUP} already exists"

fi


########################################
# User
########################################

if ! id "${ODOO_USER}" >/dev/null 2>&1; then

    info "Creating user ${ODOO_USER}"

    useradd \
        --system \
        --gid "${ODOO_GROUP}" \
        --home-dir "${ODOO_HOME}" \
        --shell /bin/bash \
        "${ODOO_USER}"

else

    info "User ${ODOO_USER} already exists"

fi


########################################
# Ownership
########################################

info "Setting permissions"

chown -R "${ODOO_USER}:${ODOO_GROUP}" "${ODOO_HOME}"


success "Odoo user created"
