#!/usr/bin/env bash
#
# Vina Business Server Installer
# Module: 02-system-update
#

set -Eeuo pipefail


BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "${BASE_DIR}/lib/colors.sh"
source "${BASE_DIR}/lib/functions.sh"
source "${BASE_DIR}/config/installer.conf"


echo
echo "========================================"
echo " System Update & Base Configuration"
echo "========================================"
echo


info "Updating package list..."

apt update


info "Upgrading system packages..."

DEBIAN_FRONTEND=noninteractive apt upgrade -y


info "Installing timezone..."

timedatectl set-timezone "${TIMEZONE}"


info "Generating locale..."

locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8


info "Cleaning apt cache..."

apt autoremove -y
apt autoclean


success "System update completed"
