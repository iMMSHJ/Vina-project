#!/usr/bin/env bash
#
# Vina Business Server Installer
# Module: 01-bootstrap
#

set -Eeuo pipefail


BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "${BASE_DIR}/lib/colors.sh"
source "${BASE_DIR}/lib/functions.sh"


echo
echo "========================================"
echo " Bootstrap Minimal Ubuntu"
echo "========================================"
echo


info "Updating apt cache..."

apt update


PACKAGES_FILE="${BASE_DIR}/config/apt-packages.list"

if [[ ! -f "${PACKAGES_FILE}" ]]; then
    error "Package list not found: ${PACKAGES_FILE}"
fi

mapfile -t PACKAGES < <(grep -vE '^\s*(#|$)' "${PACKAGES_FILE}")


info "Installing base packages..."


apt install -y "${PACKAGES[@]}"
if ! command -v locale-gen >/dev/null 2>&1; then
    apt install -y locales
fi

success "Bootstrap completed"
