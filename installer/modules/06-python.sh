#!/usr/bin/env bash
#
# Vina Business Server Installer
# Module: 06-python
#

set -Eeuo pipefail


BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "${BASE_DIR}/lib/colors.sh"
source "${BASE_DIR}/lib/functions.sh"
source "${BASE_DIR}/config/installer.conf"


info "Checking Python build dependencies..."

apt-get install -y \
python3.12-dev \
python3.12-venv \
build-essential \
pkg-config \
libpq-dev \
libldap2-dev \
libsasl2-dev


echo
echo "========================================"
echo " Python Environment Setup"
echo "========================================"
echo


########################################
# Create Odoo directories
########################################

info "Creating Odoo directories..."

mkdir -p \
"${ODOO_HOME}" \
"${ODOO_SOURCE}" \
"${ODOO_CUSTOM_ADDONS}" \
"${ODOO_OCA}"


########################################
# Ownership
########################################

chown -R "${ODOO_USER}:${ODOO_GROUP}" "${ODOO_HOME}"


########################################
# Create Virtual Environment
########################################

if [ ! -d "${ODOO_VENV}" ]; then

    info "Creating Python virtual environment..."

    python3 -m venv "${ODOO_VENV}"

else

    info "Virtual environment already exists"

fi


########################################
# Upgrade pip tools
########################################

info "Updating pip tools..."

"${ODOO_VENV}/bin/pip" install \
    --upgrade \
    pip \
    setuptools \
    wheel


########################################
# Install Python dependencies
########################################

if [ -f "${BASE_DIR}/config/python-packages.list" ]; then

    info "Installing Python packages..."

    "${ODOO_VENV}/bin/pip" install \
        -r "${BASE_DIR}/config/python-packages.list"

else

    warning "Python package list not found"

fi


########################################
# Permissions
########################################

chown -R "${ODOO_USER}:${ODOO_GROUP}" "${ODOO_HOME}"


########################################
# Report Engine (headless Chrome for PDF)
########################################
#
# Ubuntu's "chromium" apt package is a snap wrapper, which doesn't
# work reliably on a headless server (needs snapd + an interactive
# confirmation). Google Chrome's own apt repo installs a real .deb
# with no snap dependency, which is what Odoo's report engine looks
# for (it auto-detects google-chrome/chromium/chromium-browser in PATH).

if [ "${REPORT_ENGINE}" = "chromium" ]; then

    if ! command_exists google-chrome; then

        info "Installing Google Chrome (headless PDF report engine)..."

        install -d -m 0755 /etc/apt/keyrings

        curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
            | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg

        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
            > /etc/apt/sources.list.d/google-chrome.list

        apt update
        apt install -y google-chrome-stable

    else

        info "Google Chrome already installed"

    fi

else

    warning "REPORT_ENGINE is not 'chromium', skipping headless browser install"

fi


########################################
# rtlcss (required for RTL languages, e.g. Persian/Arabic)
########################################

if command_exists npm; then

    if ! command_exists rtlcss; then

        info "Installing rtlcss (npm, global)..."

        npm install -g rtlcss

    else

        info "rtlcss already installed"

    fi

else

    warning "npm not found, cannot install rtlcss - RTL languages (e.g. Persian) will render incorrectly"

fi


success "Python environment ready"
