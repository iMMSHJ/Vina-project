#!/usr/bin/env bash
#
# Vina Business Server Installer
# Module: 04-postgresql
#

set -Eeuo pipefail


BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "${BASE_DIR}/lib/colors.sh"
source "${BASE_DIR}/lib/functions.sh"
source "${BASE_DIR}/config/installer.conf"


echo
echo "========================================"
echo " PostgreSQL Installation & Setup"
echo "========================================"
echo


########################################
# Install PostgreSQL
########################################

info "Installing PostgreSQL..."

apt install -y \
    postgresql \
    postgresql-contrib \
    libpq-dev


########################################
# Enable Service
########################################

info "Enabling PostgreSQL service..."

systemctl enable postgresql
systemctl start postgresql


########################################
# Check Service
########################################

if systemctl is-active --quiet postgresql; then

    success "PostgreSQL is running"

else

    error "PostgreSQL failed to start"

fi


########################################
# Create Odoo Database User
########################################

if sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${POSTGRES_USER}'" | grep -q 1
then

    info "Database user ${POSTGRES_USER} already exists"

else

    info "Creating database user ${POSTGRES_USER}"

    sudo -u postgres createuser \
        --createdb \
        --no-superuser \
        --no-createrole \
        "${POSTGRES_USER}"

fi


########################################
# Set Database Role Password
########################################
#
# Prompted interactively and applied straight into PostgreSQL via
# ALTER ROLE. Nothing is written to any installer file, env file, or
# log — it only ever lives in PostgreSQL's own credential store.
# The Odoo service itself does NOT need this password: odoo.conf uses
# db_host = False so Odoo connects over the local Unix socket, which
# is authenticated by "peer" (matching the odoo Linux user), not by
# password. This password exists for admins who need direct psql/TCP
# access to the database, e.g. from a backup host or DBA tool.

info "Setting PostgreSQL password for role ${POSTGRES_USER}"

while true; do

    read -rs -p "Enter PostgreSQL password for role '${POSTGRES_USER}': " PG_ROLE_PASSWORD
    echo
    read -rs -p "Confirm password: " PG_ROLE_PASSWORD_CONFIRM
    echo

    if [[ -z "${PG_ROLE_PASSWORD}" ]]; then
        warning "Password cannot be empty, try again"
        continue
    fi

    if [[ "${PG_ROLE_PASSWORD}" != "${PG_ROLE_PASSWORD_CONFIRM}" ]]; then
        warning "Passwords did not match, try again"
        continue
    fi

    break

done

sudo -u postgres psql -v ON_ERROR_STOP=1 \
    -c "ALTER ROLE \"${POSTGRES_USER}\" WITH PASSWORD '${PG_ROLE_PASSWORD}';" \
    >/dev/null

unset PG_ROLE_PASSWORD PG_ROLE_PASSWORD_CONFIRM

success "PostgreSQL role password set (not stored on disk)"


########################################
# PostgreSQL Basic Hardening
########################################

info "Applying PostgreSQL basic security settings"


PG_VERSION=$(ls /etc/postgresql | tail -1)

PG_CONF="/etc/postgresql/${PG_VERSION}/main/postgresql.conf"


if [ -f "${PG_CONF}" ]; then

    sed -i "s/^#listen_addresses =.*/listen_addresses = 'localhost'/" "${PG_CONF}"

    sed -i "s/^#password_encryption =.*/password_encryption = scram-sha-256/" "${PG_CONF}"

fi


########################################
# Restart PostgreSQL
########################################

systemctl restart postgresql


success "PostgreSQL setup completed"
