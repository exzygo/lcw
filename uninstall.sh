#!/bin/bash

set -e

BIN_DIR="/usr/local/bin/lcw"
SHARE_DIR="/usr/local/share/lcw"

echo "==> Removing lcw >> $BIN_DIR..."
if [ -f "$BIN_DIR" ]; then
    rm -f "$BIN_DIR"
    echo "  - Removed: $BIN_DIR"
else
    echo "  - File not founded: $BIN_DIR"
fi

echo "==> Removing setup files >> $SHARE_DIR..."
if [ -d "$SHARE_DIR" ]; then
    rm -rf "$SHARE_DIR"
    echo "  - Directory removed: $SHARE_DIR"
else
    echo "  - Directory not founded: $SHARE_DIR"
fi

echo ""
echo "Uninstallation completed!"

