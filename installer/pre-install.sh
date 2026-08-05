#!/usr/bin/env bash
#
# Create Business Server Installer Structure
#

set -euo pipefail

BASE="/opt/installer"

echo "Creating Business Server Installer..."

mkdir -p "$BASE"

DIRS=(
config
lib
modules
templates
scripts
docs
logs
)

for dir in "${DIRS[@]}"; do
    mkdir -p "$BASE/$dir"
done

touch "$BASE/install.sh"
touch "$BASE/README.md"
echo "1.0.0" > "$BASE/VERSION"
touch "$BASE/.gitignore"

echo "Business Server Installer structure created."

if command -v tree >/dev/null 2>&1; then
    tree "$BASE"
else
    find "$BASE"
fi
