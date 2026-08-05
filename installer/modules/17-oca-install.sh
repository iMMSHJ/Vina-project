#!/bin/bash

set -e

echo "========================================"
echo " OCA Addons Installation"
echo "========================================"


BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

OCA_DIR="/opt/odoo/oca"
OCA_LIST_FILE="${BASE_DIR}/config/oca.list"

echo "[INFO] Creating OCA directory..."

mkdir -p "$OCA_DIR"


echo "[INFO] Preparing repositories list..."


if [ ! -f "$OCA_LIST_FILE" ]; then
    echo "[ERROR] OCA repo list not found: $OCA_LIST_FILE"
    exit 1
fi

mapfile -t OCA_REPOS < <(grep -vE '^\s*(#|$)' "$OCA_LIST_FILE")

OCA_SELECTION=$(dialog --checklist "Select OCA modules:" 20 60 15 \
    "server-tools" "Server Tools" on \
    "web" "Web" on \
    "helpdesk" "Helpdesk" off \
    ... 3>&1 1>&2 2>&3)

clone_oca_repo() {

    REPO=$1

    TARGET="$OCA_DIR/$REPO"

    URL="https://github.com/OCA/$REPO.git"


    if [ -d "$TARGET" ]; then
        echo "[SKIP] $REPO already exists"
        return
    fi


    echo "[INFO] Checking $REPO ..."


    if git ls-remote --heads "$URL" | grep -q "refs/heads/19.0"; then

        echo "[INFO] Cloning $REPO branch 19.0"

        sudo -u odoo git clone \
            --depth 1 \
            --branch 19.0 \
            "$URL" \
            "$TARGET"

    else

        echo "[WARN] No 19.0 branch for $REPO"
        echo "[INFO] Using default branch"

        sudo -u odoo git clone \
            --depth 1 \
            "$URL" \
            "$TARGET"

    fi

}



for repo in "${OCA_REPOS[@]}"
do
    clone_oca_repo "$repo"
done



echo "[INFO] Setting permissions..."

chown -R odoo:odoo /opt/odoo/oca



echo "[INFO] Updating addon paths..."

echo
echo "Installed OCA modules:"
ls -1 "$OCA_DIR"



echo
echo "[OK] OCA installation completed"
