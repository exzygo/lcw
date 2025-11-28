#!/bin/bash

set -e

BIN_DIR="/usr/local/bin"
SHARE_DIR="/usr/local/share/lcw"
SETUP_DIR="$SHARE_DIR/setup"

echo "==> Installing lcw >> $BIN_DIR..."
install -m 755 src/lcw "$BIN_DIR/lcw"

echo "==> Creating setup directory >> $SETUP_DIR..."
mkdir -p "$SETUP_DIR"

echo "==> Installing setup files..."
install -m 644 src/setup/* "$SETUP_DIR/"

echo "==> Alles klar:"
echo "  - Binary installed on: $BIN_DIR/lcw"
echo "  - Setup files installed on: $SETUP_DIR"
echo ""
echo "Installation complete!"

