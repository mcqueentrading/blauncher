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

# Check if blauncher is installed
if [ ! -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
    echo "⚠️  blauncher is not installed in $INSTALL_DIR"
    echo ""
    
    # Check if it's in bashrc directly
    if [ -f "$BASHRC" ] && grep -q "oo()" "$BASHRC" 2>/dev/null; then
        echo "Found blauncher code in ~/.bashrc"
        read -p "Do you want to remove it from ~/.bashrc? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Create backup
            cp "$BASHRC" "$BASHRC.backup.$(date +%Y%m%d_%H%M%S)"
            echo "✓ Created backup: $BASHRC.backup.*"
            
            # Remove blauncher sections
            sed -i '/# blauncher/,/complete.*_orphan_complete/d' "$BASHRC"
            sed -i '/# --- orphan wrappers ---/,/complete.*_orphan_complete/d' "$BASHRC"
            sed -i '/# Source blauncher/,/source.*blauncher/d' "$BASHRC"
            
            echo "✓ Removed blauncher from ~/.bashrc"
        fi
    fi
    
    echo ""
    echo "Uninstall complete."
    exit 0
fi

echo "Found blauncher at: $INSTALL_DIR/$SCRIPT_NAME"
echo ""

read -p "Are you sure you want to uninstall blauncher? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstall cancelled."
    exit 0
fi

# Remove the script
echo ""
echo "Removing $INSTALL_DIR/$SCRIPT_NAME..."
rm -f "$INSTALL_DIR/$SCRIPT_NAME"
echo "✓ Removed script file"

# Remove from bashrc if present
if [ -f "$BASHRC" ] && grep -q "blauncher" "$BASHRC" 2>/dev/null; then
    echo ""
    echo "Found blauncher references in ~/.bashrc"
    read -p "Do you want to remove them? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Create backup
        cp "$BASHRC" "$BASHRC.backup.$(date +%Y%m%d_%H%M%S)"
        echo "✓ Created backup: $BASHRC.backup.*"
        
        # Remove sourcing lines
        sed -i '/# Source blauncher/,/source.*blauncher/d' "$BASHRC"
        
        echo "✓ Removed blauncher from ~/.bashrc"
        echo ""
        echo "⚠️  You may need to run: source ~/.bashrc"
    fi
fi

echo ""
echo "✅ blauncher has been uninstalled."
echo ""
echo "Note: Your shell functions (oo, op, orp) will remain active"
echo "      in current sessions until you reload your shell."
echo ""
