#!/bin/bash
set -e

echo "========================================"
echo " Preflight Check"
echo "========================================"

REQUIRED_PACKAGES="
build-essential
pkg-config
python3.12-dev
python3.12-venv
libpq-dev
libldap2-dev
libsasl2-dev
"

for pkg in $REQUIRED_PACKAGES
do
    if ! dpkg -s $pkg >/dev/null 2>&1
    then
        echo "[ERROR] Missing package: $pkg"
        exit 1
    fi
done


if [ ! -f /usr/include/python3.12/Python.h ]; then
    echo "[ERROR] Python headers missing"
    exit 1
fi


echo "[OK] System requirements satisfied"
