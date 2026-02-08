# blauncher Installation Guide

## Installation (Modular Method)

blauncher installs as a separate file in `~/.local/bin/` and adds a single source line to your `~/.bashrc`.

### Why This Approach?

**What it does:**
- Installs `blauncher.sh` to `~/.local/bin/`
- Adds ONE line to your `~/.bashrc` to source it
- Keeps your bashrc clean and organized

**Benefits:**
✅ Clean `~/.bashrc` (just 1 line instead of 80+)  
✅ Easy to update (just replace one file)  
✅ Easy to remove (run uninstall script)  
✅ Standard location for user scripts  
✅ Better for multi-user systems  
✅ Easier to share your dotfiles  
✅ Professional and maintainable  

---

## Quick Install

### Automated Installation (Recommended)

```bash
# Download and run the installer
curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/install-modular.sh | bash

# Reload your shell
source ~/.bashrc
```

### Manual Installation

If you prefer to install manually or don't want to pipe to bash:

```bash
# 1. Create directory if it doesn't exist
mkdir -p ~/.local/bin

# 2. Download blauncher.sh
curl -o ~/.local/bin/blauncher.sh https://raw.githubusercontent.com/mcqueentrading/blauncher/main/blauncher.sh

# 3. Make it executable
chmod +x ~/.local/bin/blauncher.sh

# 4. Add to bashrc (only if not already added)
echo '[ -f "$HOME/.local/bin/blauncher.sh" ] && source "$HOME/.local/bin/blauncher.sh"' >> ~/.bashrc

# 5. Ensure ~/.local/bin is in PATH (if needed)
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

# 6. Reload your shell
source ~/.bashrc
```

---

## What Gets Added to Your ~/.bashrc

Only this single line:

```bash
# Source blauncher for oo, op, orp commands
[ -f "$HOME/.local/bin/blauncher.sh" ] && source "$HOME/.local/bin/blauncher.sh"
```

That's it! Clean and simple.

---

## Uninstallation

### Automated Uninstall (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/uninstall.sh | bash
```

### Manual Uninstall

```bash
# 1. Remove the script
rm ~/.local/bin/blauncher.sh

# 2. Remove the source line from ~/.bashrc
# Open ~/.bashrc in your editor and delete these lines:
#   # Source blauncher for oo, op, orp commands
#   [ -f "$HOME/.local/bin/blauncher.sh" ] && source "$HOME/.local/bin/blauncher.sh"

# 3. Reload your shell
source ~/.bashrc
```

---

## Verification

After installation, verify everything works:

```bash
# Check if functions exist
for func in oo op orp; do
    if type $func &>/dev/null; then
        echo "✓ $func is available"
    else
        echo "✗ $func is NOT available"
    fi
done

# Check if tab completion is registered
for func in oo op orp; do
    if complete -p $func &>/dev/null; then
        echo "✓ $func has tab completion"
    else
        echo "✗ $func does NOT have tab completion"
    fi
done
```

All should show ✓ checkmarks.

---

## Testing Your Installation

Try these commands to make sure everything works:

```bash
# Test that functions are loaded
type oo op orp

# Expected output:
# oo is a function
# op is a function
# orp is a function

# Test tab completion
oo fire<TAB>    # Should complete to: oo firefox (if firefox is installed)

# Test launching (if you have these apps)
oo firefox
op nemo ~/Downloads
```

---

## File Locations

After installation:

```
~/.local/bin/blauncher.sh    ← The blauncher script
~/.bashrc                    ← Contains 1 line to source blauncher
```

---

## Troubleshooting

### "command not found" after installation

Make sure `~/.local/bin` is in your PATH:

```bash
echo $PATH | grep -q "$HOME/.local/bin" && echo "In PATH ✓" || echo "Not in PATH ✗"
```

If not in PATH, add it:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Functions don't work

Make sure you've reloaded your shell:

```bash
source ~/.bashrc
```

Or open a new terminal.

### Uninstall doesn't remove the source line

The updated uninstall script properly removes all blauncher references. If you're still seeing it:

1. Download the latest uninstall script:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/uninstall.sh | bash
   ```

2. Or manually edit `~/.bashrc` and remove:
   ```bash
   # Source blauncher for oo, op, orp commands
   [ -f "$HOME/.local/bin/blauncher.sh" ] && source "$HOME/.local/bin/blauncher.sh"
   ```

---

## Advanced: Custom Installation Location

If you want to install blauncher somewhere other than `~/.local/bin`:

```bash
# Example: install to ~/bin
INSTALL_DIR="$HOME/bin"

mkdir -p "$INSTALL_DIR"
curl -o "$INSTALL_DIR/blauncher.sh" https://raw.githubusercontent.com/mcqueentrading/blauncher/main/blauncher.sh
chmod +x "$INSTALL_DIR/blauncher.sh"

# Add to bashrc
echo "[ -f \"$INSTALL_DIR/blauncher.sh\" ] && source \"$INSTALL_DIR/blauncher.sh\"" >> ~/.bashrc

# Make sure $INSTALL_DIR is in PATH
echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> ~/.bashrc

source ~/.bashrc
```

---

## Need Help?

- **Questions?** [Open an issue](https://github.com/mcqueentrading/blauncher/issues)
- **Bugs?** [Report here](https://github.com/mcqueentrading/blauncher/issues/new)
- **Documentation:** [README.md](README.md)
- **Examples:** [EXAMPLES.md](EXAMPLES.md)

---

**Happy launching! 🚀**
