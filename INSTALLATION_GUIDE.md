# blauncher Installation Guide

Complete installation instructions for blauncher — a lightweight Bash utility for launching GUI applications as fully detached processes.

---

## Quick Install (Recommended)

The fastest way to install blauncher:

```bash
# Download and run the installer
curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/blauncher.sh | bash

# Reload your shell
source ~/.bashrc
```

**That's it!** The installer will:
- ✅ Download the blauncher script to `~/.local/bin/`
- ✅ Add `~/.local/bin` to your PATH (if not already present)
- ✅ Add one line to `~/.bashrc` to source blauncher
- ✅ Handle existing installations gracefully
- ✅ Create a backup before updating (`~/.bashrc.bak`)

---

## What the Installer Does

### Step-by-Step Process

1. **Creates `~/.local/bin`** (if it doesn't exist)
   ```
   Creating ~/.local/bin...
   ```

2. **Adds to PATH** (if needed)
   ```
   Adding ~/.local/bin to PATH in ~/.bashrc...
   ✓ PATH updated in ~/.bashrc
   ```
   
   Or if already in PATH:
   ```
   ✓ PATH already configured in ~/.bashrc
   ```

3. **Downloads blauncher**
   ```
   📥 Downloading blauncher.sh...
   ✓ Installed to ~/.local/bin/blauncher.sh
   ```

4. **Updates `~/.bashrc`**
   
   If blauncher is not already sourced:
   ```
   📝 Adding blauncher to ~/.bashrc...
   ✓ Updated ~/.bashrc
   ```
   
   If blauncher is already installed:
   ```
   ⚠️  blauncher sourcing already exists in ~/.bashrc
   
   Do you want to update it? (y/N):
   ```
   - Press `y` to update (creates backup as `~/.bashrc.bak`)
   - Press `N` to skip the update

5. **Installation Complete**
   ```
   ✅ Installation complete!
   
   blauncher is installed to: ~/.local/bin/blauncher.sh
   
   To start using blauncher, run:
     source ~/.bashrc
   
   Or open a new terminal.
   ```

---

## What Gets Added to Your ~/.bashrc

The installer adds **just one line** to your `~/.bashrc`:

```bash
# Source blauncher for oo, op, orp commands
[ -f "$HOME/.local/bin/blauncher.sh" ] && source "$HOME/.local/bin/blauncher.sh"
```

**Why this approach?**
- ✅ **Clean** — Only 1 line instead of 80+ lines of code
- ✅ **Maintainable** — Update by replacing one file
- ✅ **Standard** — Uses `~/.local/bin` (XDG Base Directory spec)
- ✅ **Shareable** — Easy to include in dotfiles repos
- ✅ **Professional** — Separates concerns (install vs. functionality)

If `~/.local/bin` isn't in your PATH, it also adds:

```bash
# Add ~/.local/bin to PATH
export PATH="$HOME/.local/bin:$PATH"
```

---

## Manual Installation

If you prefer not to pipe to bash, here's how to install manually:

### Step 1: Create Directory

```bash
mkdir -p ~/.local/bin
```

### Step 2: Download blauncher

Choose one method:

**Using curl:**
```bash
curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/blauncher.sh -o ~/.local/bin/blauncher.sh
```

**Using wget:**
```bash
wget -q https://raw.githubusercontent.com/mcqueentrading/blauncher/main/blauncher.sh -O ~/.local/bin/blauncher.sh
```

**Or download the installer first:**
```bash
curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/blauncher.sh -o install-blauncher.sh
chmod +x install-blauncher.sh
./install-blauncher.sh
```

### Step 3: Make Executable

```bash
chmod +x ~/.local/bin/blauncher.sh
```

### Step 4: Add to PATH (if needed)

Check if `~/.local/bin` is in your PATH:

```bash
echo $PATH | grep -q "$HOME/.local/bin" && echo "Already in PATH ✓" || echo "Not in PATH ✗"
```

If not in PATH, add it:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

### Step 5: Source in ~/.bashrc

Add the source line:

```bash
echo '[ -f "$HOME/.local/bin/blauncher.sh" ] && source "$HOME/.local/bin/blauncher.sh"' >> ~/.bashrc
```

### Step 6: Reload Shell

```bash
source ~/.bashrc
```

---

## Verification

After installation, verify everything is working:

### Test 1: Check Functions Exist

```bash
type oo op orp
```

Expected output:
```
oo is a function
op is a function
orp is a function
```

### Test 2: Check Tab Completion

```bash
complete -p oo op orp
```

Expected output:
```
complete -o nospace -F _orphan_complete oo
complete -o nospace -F _orphan_complete op
complete -o nospace -F _orphan_complete orp
```

### Test 3: Try Tab Completion

```bash
oo fire<TAB>    # Should complete to: oo firefox (if firefox is installed)
```

### Test 4: Launch an Application

```bash
# Test with a simple command (if you have these apps)
oo firefox
op nemo ~/Downloads
orp chromium
```

### Quick Verification Script

Copy and run this to check everything:

```bash
echo "=== Checking blauncher installation ==="
echo ""

# Check if functions exist
for func in oo op orp; do
    if type $func &>/dev/null; then
        echo "✓ $func is available"
    else
        echo "✗ $func is NOT available"
    fi
done

echo ""

# Check if tab completion is registered
for func in oo op orp; do
    if complete -p $func &>/dev/null; then
        echo "✓ $func has tab completion"
    else
        echo "✗ $func does NOT have tab completion"
    fi
done

echo ""

# Check PATH
if echo $PATH | grep -q "$HOME/.local/bin"; then
    echo "✓ ~/.local/bin is in PATH"
else
    echo "✗ ~/.local/bin is NOT in PATH"
fi

echo ""
echo "=== Installation check complete ==="
```

All checks should show ✓ marks.

---

## Updating blauncher

To update to the latest version:

```bash
# Re-run the installer
curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/blauncher.sh | bash

# When prompted about existing installation, press 'y' to update
# Reload your shell
source ~/.bashrc
```

The installer will:
- Detect the existing installation
- Ask if you want to update
- Create a backup of your `~/.bashrc` before updating
- Download the latest version

---

## Uninstallation

### Automated Uninstall (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/uninstall.sh | bash
```

The uninstaller will:
- Remove `~/.local/bin/blauncher.sh`
- Remove the source line from `~/.bashrc`
- Clean up all blauncher-related entries

### Manual Uninstall

If you prefer to uninstall manually:

```bash
# 1. Remove the script
rm ~/.local/bin/blauncher.sh

# 2. Edit ~/.bashrc and remove these lines:
#    # Source blauncher for oo, op, orp commands
#    [ -f "$HOME/.local/bin/blauncher.sh" ] && source "$HOME/.local/bin/blauncher.sh"

# 3. Reload your shell
source ~/.bashrc
```

**Using sed to remove automatically:**

```bash
# Remove blauncher sourcing lines
sed -i.bak '/# Source blauncher/d; /source.*blauncher\.sh/d; /\. .*blauncher\.sh/d' ~/.bashrc

# Remove the script
rm ~/.local/bin/blauncher.sh

# Reload
source ~/.bashrc
```

---

## File Locations After Installation

```
~/.local/bin/blauncher.sh    ← The blauncher script (contains all functions)
~/.bashrc                    ← Contains 1 line to source blauncher
~/.bashrc.bak               ← Backup (created when updating)
```

---

## Troubleshooting

### "command not found" after installation

**Problem:** The `oo`, `op`, `orp` commands aren't recognized.

**Solutions:**

1. Make sure you've reloaded your shell:
   ```bash
   source ~/.bashrc
   ```
   Or open a new terminal window.

2. Check if `~/.local/bin` is in your PATH:
   ```bash
   echo $PATH | grep -q "$HOME/.local/bin" && echo "In PATH ✓" || echo "Not in PATH ✗"
   ```
   
   If not in PATH:
   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

3. Verify the script exists and is executable:
   ```bash
   ls -la ~/.local/bin/blauncher.sh
   ```
   
   Should show: `-rwxr-xr-x` (executable permissions)
   
   If not executable:
   ```bash
   chmod +x ~/.local/bin/blauncher.sh
   ```

### Functions don't work after sourcing

**Problem:** You ran `source ~/.bashrc` but commands still don't work.

**Check:**

1. Verify the source line is in `~/.bashrc`:
   ```bash
   grep blauncher ~/.bashrc
   ```
   
   Should show:
   ```
   [ -f "$HOME/.local/bin/blauncher.sh" ] && source "$HOME/.local/bin/blauncher.sh"
   ```

2. Manually source the script to test:
   ```bash
   source ~/.local/bin/blauncher.sh
   type oo
   ```

3. Check for errors in `~/.bashrc`:
   ```bash
   bash -n ~/.bashrc
   ```
   (No output means no syntax errors)

### Tab completion not working

**Problem:** Tab completion doesn't work for `oo`, `op`, `orp`.

**Solutions:**

1. Make sure bash-completion is installed:
   ```bash
   # Ubuntu/Debian
   sudo apt install bash-completion
   
   # Fedora
   sudo dnf install bash-completion
   
   # Arch
   sudo pacman -S bash-completion
   ```

2. Reload your shell:
   ```bash
   source ~/.bashrc
   ```

3. Check if completion is registered:
   ```bash
   complete -p oo op orp
   ```

### Installer says "Neither curl nor wget found"

**Problem:** Your system doesn't have curl or wget installed.

**Solutions:**

Install either curl or wget:

```bash
# Ubuntu/Debian
sudo apt install curl

# Fedora
sudo dnf install curl

# Arch
sudo pacman -S curl

# macOS (usually pre-installed)
brew install curl
```

### Reinstalling after failed installation

**Problem:** Installation failed midway and you want to start fresh.

**Solution:**

1. Remove any partial installation:
   ```bash
   rm -f ~/.local/bin/blauncher.sh
   sed -i.bak '/blauncher/d' ~/.bashrc
   ```

2. Run the installer again:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/blauncher.sh | bash
   ```

### Installation works but commands don't persist

**Problem:** Commands work in current terminal but not in new terminals.

**Check:**

1. Make sure the source line is actually in `~/.bashrc`:
   ```bash
   grep blauncher ~/.bashrc
   ```

2. Make sure you're using bash (not zsh or fish):
   ```bash
   echo $SHELL
   ```
   
   If using zsh, add to `~/.zshrc` instead:
   ```bash
   echo '[ -f "$HOME/.local/bin/blauncher.sh" ] && source "$HOME/.local/bin/blauncher.sh"' >> ~/.zshrc
   ```

---

## Advanced: Custom Installation Location

If you want to install blauncher somewhere other than `~/.local/bin`:

```bash
# Set custom installation directory
INSTALL_DIR="$HOME/bin"  # or any directory you prefer

# Create the directory
mkdir -p "$INSTALL_DIR"

# Download blauncher
curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/blauncher.sh -o "$INSTALL_DIR/blauncher.sh"
chmod +x "$INSTALL_DIR/blauncher.sh"

# Add to PATH (if needed)
echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> ~/.bashrc

# Source blauncher
echo "[ -f \"$INSTALL_DIR/blauncher.sh\" ] && source \"$INSTALL_DIR/blauncher.sh\"" >> ~/.bashrc

# Reload
source ~/.bashrc
```

---

## Platform-Specific Notes

### Ubuntu/Debian

Works out of the box. Just run the installer.

### Fedora/RHEL/CentOS

Works out of the box. Make sure `curl` is installed.

### Arch Linux

Works out of the box. Consider installing `bash-completion` for better tab completion:
```bash
sudo pacman -S bash-completion
```

### macOS

Works on macOS with minor differences:
- `~/.local/bin` might not exist by default (installer creates it)
- Some GNU tools behave slightly differently
- Tab completion works with default bash or zsh

For zsh users, add to `~/.zshrc` instead of `~/.bashrc`.

### WSL (Windows Subsystem for Linux)

Works perfectly on WSL. Follow the standard installation instructions.

---

## Need Help?

- **Questions?** [Open an issue](https://github.com/mcqueentrading/blauncher/issues)
- **Bugs?** [Report here](https://github.com/mcqueentrading/blauncher/issues/new)
- **Documentation:** [README.md](README.md)
- **Examples:** [EXAMPLES.md](EXAMPLES.md)

---

**Happy launching! 🚀**
