#!/usr/bin/env bash
#
# Vina Business Server Installer
# Module: 00-precheck
#

set -Eeuo pipefail


########################################
# Load libraries
########################################

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "${BASE_DIR}/lib/colors.sh"
source "${BASE_DIR}/lib/functions.sh"


########################################
# Start
########################################

echo
echo "========================================"
echo " Pre-installation Check"
echo "========================================"
echo


########################################
# Root Check
########################################

if [[ $EUID -ne 0 ]]; then
    error "Installer must run as root"
fi

success "Running as root"


########################################
# OS Check
########################################

if [[ -f /etc/os-release ]]; then

    source /etc/os-release

    info "OS: ${PRETTY_NAME}"

else

    error "Cannot detect operating system"

fi


if [[ "${ID}" != "ubuntu" ]]; then

    warning "This installer is designed for Ubuntu"

fi


success "OS check completed"


########################################
# Architecture
########################################

ARCH=$(uname -m)

info "Architecture: ${ARCH}"


########################################
# CPU
########################################

CPU=$(nproc)

info "CPU Cores: ${CPU}"


########################################
# RAM
########################################

RAM=$(free -m | awk '/Mem:/ {print $2}')

info "RAM: ${RAM} MB"


########################################
# Disk
########################################

DISK=$(df -h / | awk 'NR==2 {print $4}')

info "Free Disk: ${DISK}"


########################################
# Internet
########################################

if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1
then

    success "Internet connection OK"

else

    warning "Internet connection failed"

fi


########################################
# Finish
########################################

echo

success "Pre-check completed successfully"
