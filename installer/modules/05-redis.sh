#!/usr/bin/env bash
#
# Vina Business Server Installer
# Module: 05-redis
#

set -Eeuo pipefail


BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "${BASE_DIR}/lib/colors.sh"
source "${BASE_DIR}/lib/functions.sh"
source "${BASE_DIR}/config/installer.conf"


echo
echo "========================================"
echo " Redis Installation & Hardening"
echo "========================================"
echo


########################################
# Install Redis
########################################

info "Installing Redis..."

apt install -y redis-server


########################################
# Enable Service
########################################

info "Enabling Redis service..."

systemctl enable redis-server
systemctl start redis-server


########################################
# Redis Configuration
########################################

REDIS_CONF="/etc/redis/redis.conf"


if [ -f "${REDIS_CONF}" ]; then

    info "Applying Redis security settings"


    # Only local access
    sed -i "s/^bind .*/bind 127.0.0.1 ::1/" "${REDIS_CONF}"


    # Enable protected mode
    sed -i "s/^protected-mode .*/protected-mode yes/" "${REDIS_CONF}"


    # Memory policy suitable for application cache
    if grep -q "^maxmemory-policy" "${REDIS_CONF}"
    then
        sed -i "s/^maxmemory-policy .*/maxmemory-policy allkeys-lru/" "${REDIS_CONF}"
    else
        echo "maxmemory-policy allkeys-lru" >> "${REDIS_CONF}"
    fi


fi


########################################
# Restart Redis
########################################

systemctl restart redis-server


########################################
# Test Redis
########################################

if redis-cli ping | grep -q PONG
then

    success "Redis connection OK"

else

    error "Redis test failed"

fi


success "Redis setup completed"
