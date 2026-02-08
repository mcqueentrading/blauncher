#!/usr/bin/env bash
# blauncher uninstaller - removes blauncher from system

set -e

INSTALL_DIR="$HOME/.local/bin"
BASHRC="$HOME/.bashrc"
SCRIPT_NAME="blauncher.sh"

echo "==============================================="
echo "  blauncher uninstaller"
echo "==============================================="
echo ""

FILE_FOUND=false
BASHRC_FOUND=false

# Check if blauncher file exists
if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
    echo "✓ Found blauncher at: $INSTALL_DIR/$SCRIPT_NAME"
    FILE_FOUND=true
else
    echo "⚠️  blauncher file not found in $INSTALL_DIR"
fi

# Check if blauncher is in bashrc (either sourcing or inline code)
if [ -f "$BASHRC" ]; then
    if grep -q "blauncher" "$BASHRC" 2>/dev/null || grep -q "oo()" "$BASHRC" 2>/dev/null; then
        echo "✓ Found blauncher references in ~/.bashrc"
        BASHRC_FOUND=true
    else
        echo "⚠️  No blauncher references found in ~/.bashrc"
    fi
fi

echo ""

# If nothing found, exit
if [ "$FILE_FOUND" = false ] && [ "$BASHRC_FOUND" = false ]; then
    echo "Nothing to uninstall. blauncher is not installed."
    exit 0
fi

# Confirm uninstall
read -p "Do you want to uninstall blauncher? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstall cancelled."
    exit 0
fi

echo ""

# Remove the script file if it exists
if [ "$FILE_FOUND" = true ]; then
    echo "Removing $INSTALL_DIR/$SCRIPT_NAME..."
    rm -f "$INSTALL_DIR/$SCRIPT_NAME"
    echo "✓ Removed script file"
    echo ""
fi

# Remove from bashrc if present
if [ "$BASHRC_FOUND" = true ]; then
    echo "Removing blauncher from ~/.bashrc..."
    
    # Create backup
    cp "$BASHRC" "$BASHRC.backup.$(date +%Y%m%d_%H%M%S)"
    echo "✓ Created backup: $BASHRC.backup.*"
    
    # Remove inline code if present (from old installation method)
    sed -i '/# blauncher/d' "$BASHRC"
    sed -i '/# --- orphan wrappers ---/,/complete.*_orphan_complete/d' "$BASHRC"
    
    # Remove sourcing lines (from modular installation)
    sed -i '/# Source blauncher/,/\[ -f.*blauncher\.sh.*\]/d' "$BASHRC"
    sed -i '\|source.*blauncher\.sh|d' "$BASHRC"
    
    echo "✓ Removed blauncher from ~/.bashrc"
    echo ""
fi

echo "✅ blauncher has been uninstalled."
echo ""
echo "Note: Your shell functions (oo, op, orp) will remain active"
echo "      in current sessions until you reload your shell with:"
echo "      source ~/.bashrc"
echo ""
