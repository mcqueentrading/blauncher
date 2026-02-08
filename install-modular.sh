#!/usr/bin/env bash
# blauncher installer - modular version
# Installs blauncher to ~/.local/bin and adds minimal sourcing to ~/.bashrc

set -e

INSTALL_DIR="$HOME/.local/bin"
BASHRC="$HOME/.bashrc"
SCRIPT_NAME="blauncher.sh"
BLAUNCHER_URL="https://raw.githubusercontent.com/mcqueentrading/blauncher/main/blauncher.sh"

echo "==============================================="
echo "  blauncher installer (modular)"
echo "==============================================="
echo ""

# Create ~/.local/bin if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR"
fi

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "⚠️  $INSTALL_DIR is not in your PATH"
    echo ""
    
    # Check if bashrc exists
    if [ ! -f "$BASHRC" ]; then
        echo "Creating ~/.bashrc..."
        touch "$BASHRC"
    fi
    
    # Add to PATH in bashrc
    echo "Adding $INSTALL_DIR to PATH in ~/.bashrc..."
    echo "" >> "$BASHRC"
    echo "# Add ~/.local/bin to PATH" >> "$BASHRC"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$BASHRC"
    echo ""
    
    echo "✓ PATH updated in ~/.bashrc"
fi

# Download or use local file
if [ -f "$SCRIPT_NAME" ]; then
    echo "✓ Using local $SCRIPT_NAME"
    cp "$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"
else
    echo "📥 Downloading $SCRIPT_NAME..."
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$BLAUNCHER_URL" -o "$INSTALL_DIR/$SCRIPT_NAME"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$BLAUNCHER_URL" -O "$INSTALL_DIR/$SCRIPT_NAME"
    else
        echo "Error: Neither curl nor wget found. Please install one of them."
        exit 1
    fi
fi

# Make executable
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
echo "✓ Installed to $INSTALL_DIR/$SCRIPT_NAME"

# Check if bashrc already sources blauncher
if [ -f "$BASHRC" ]; then
    if grep -q "source.*blauncher" "$BASHRC" 2>/dev/null; then
        echo ""
        echo "⚠️  blauncher sourcing already exists in ~/.bashrc"
        echo ""
        read -p "Do you want to update it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Skipping bashrc update."
        else
            # Remove old sourcing lines
            sed -i '/# Source blauncher/,/source.*blauncher/d' "$BASHRC"
            
            # Add new sourcing
            echo "" >> "$BASHRC"
            echo "# Source blauncher for oo, op, orp commands" >> "$BASHRC"
            echo "[ -f \"\$HOME/.local/bin/blauncher.sh\" ] && source \"\$HOME/.local/bin/blauncher.sh\"" >> "$BASHRC"
            echo ""
            echo "✓ Updated ~/.bashrc"
        fi
    else
        # Add sourcing to bashrc
        echo ""
        echo "📝 Adding blauncher to ~/.bashrc..."
        echo "" >> "$BASHRC"
        echo "# Source blauncher for oo, op, orp commands" >> "$BASHRC"
        echo "[ -f \"\$HOME/.local/bin/blauncher.sh\" ] && source \"\$HOME/.local/bin/blauncher.sh\"" >> "$BASHRC"
        echo ""
        echo "✓ Updated ~/.bashrc"
    fi
else
    echo "⚠️  ~/.bashrc not found. You'll need to manually source blauncher."
    echo "   Add this to your shell config:"
    echo "   source \"\$HOME/.local/bin/blauncher.sh\""
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "blauncher is installed to: $INSTALL_DIR/$SCRIPT_NAME"
echo ""
echo "To start using blauncher, run:"
echo "  source ~/.bashrc"
echo ""
echo "Or open a new terminal."
echo ""
echo "Usage examples:"
echo "  oo firefox                    # Launch Firefox and exit shell"
echo "  op nemo ~/Downloads           # Open file manager, keep shell"
echo "  orp chromium                  # Launch with maximum resilience"
echo ""
echo "For more information, visit:"
echo "  https://github.com/mcqueentrading/blauncher"
echo ""
