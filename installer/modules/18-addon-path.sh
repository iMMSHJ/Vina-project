#!/bin/bash

set -e

echo "========================================"
echo " Generate Odoo Addons Path"
echo "========================================"

ODOO_CONF="/etc/odoo/odoo.conf"

CORE_ADDONS="/opt/odoo/src/odoo/odoo/addons"
CUSTOM_ADDONS="/opt/odoo/custom_addons"
OCA_ROOT="/opt/odoo/oca"


echo "[INFO] Building addons path..."

ADDONS_PATH="$CORE_ADDONS"


# Custom addons
if [ -d "$CUSTOM_ADDONS" ]; then
    ADDONS_PATH="$ADDONS_PATH,$CUSTOM_ADDONS"
fi


# OCA repositories
for repo in "$OCA_ROOT"/*; do

    [ -d "$repo" ] || continue


    # فقط repo هایی که manifest دارند
    if find "$repo" -type f -name "__manifest__.py" | grep -q .; then
        
        ADDONS_PATH="$ADDONS_PATH,$repo"

    else

        echo "[SKIP] $repo"

    fi

done


echo
echo "[INFO] New addons_path:"
echo "$ADDONS_PATH"
echo


# حذف addons_path قبلی
sudo sed -i '/^addons_path[[:space:]]*=/d' "$ODOO_CONF"


# اضافه کردن بعد از options
sudo sed -i "/^\[options\]/a addons_path = $ADDONS_PATH" "$ODOO_CONF"


# permissions
sudo chown odoo:odoo "$ODOO_CONF"
sudo chmod 640 "$ODOO_CONF"


echo "[OK] addons_path updated"
