# blauncher Installation Guide

## Choose Your Installation Method

### 🎯 Method 1: Modular Install (Recommended for Most Users)

**What it does:**
- Installs `blauncher.sh` to `~/.local/bin/`
- Adds ONE line to your `~/.bashrc` to source it
- Keeps your bashrc clean and organized

**Installation:**
```bash
# Download and run the installer
curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/install-modular.sh | bash

# Reload your shell
source ~/.bashrc
```

**What gets added to ~/.bashrc:**
```bash
# Source blauncher for oo, op, orp commands
[ -f "$HOME/.local/bin/blauncher.sh" ] && source "$HOME/.local/bin/blauncher.sh"
```

**Pros:**
✅ Clean `~/.bashrc` (just 1 line)  
✅ Easy to update (just replace one file)  
✅ Easy to remove (run uninstall script)  
✅ Standard location for user scripts  
✅ Better for multi-user systems  
✅ Easier to share with others  

**Cons:**
❌ One extra file to manage  
❌ Slightly slower load (minimal, ~1ms)  

**Uninstall:**
```bash
curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/uninstall.sh | bash
```

---

### 📝 Method 2: Inline Install (For Simplicity)

**What it does:**
- Copies all blauncher code directly into your `~/.bashrc`
- Everything in one file

**Installation:**
```bash
# Download and append to bashrc
curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/blauncher.sh >> ~/.bashrc

# Reload your shell
source ~/.bashrc
```

**Pros:**
✅ Everything in one place  
✅ No external dependencies  
✅ Marginally faster (no file read)  
✅ Simpler mental model  

**Cons:**
❌ Makes `~/.bashrc` longer (80+ lines)  
❌ Harder to update (find and replace in bashrc)  
❌ Harder to remove (manual editing)  
❌ Less portable  

**Uninstall:**
Manually remove the blauncher section from `~/.bashrc` between these markers:
```bash
# blauncher - orphan process wrappers
# ...
complete -o nospace -F _orphan_complete oo op orp
```

---

## Quick Comparison

| Feature | Modular | Inline |
|---------|---------|--------|
| Clean bashrc | ✅ 1 line | ❌ 80+ lines |
| Easy to update | ✅ Replace file | ❌ Edit bashrc |
| Easy to remove | ✅ Run script | ❌ Manual edit |
| Portability | ✅ Better | ⚠️ Moderate |
| Load time | ~1ms | 0ms |
| Simplicity | ⚠️ 2 files | ✅ 1 file |

---

## Recommendation by Use Case

### Use **Modular** if you:
- Share your dotfiles publicly
- Like keeping your bashrc organized
- Want to easily update/remove
- Use multiple machines
- Collaborate with others

### Use **Inline** if you:
- Prefer everything in one file
- Rarely modify your setup
- Don't mind longer bashrc
- Want absolute simplicity

---

## Testing Your Installation

After installing with either method:

```bash
# Test the functions are loaded
type oo op orp

# Expected output:
# oo is a function
# op is a function
# orp is a function

# Test tab completion
oo fire<TAB>    # Should complete to: oo firefox

# Test launching
oo firefox
op nemo ~/Downloads
orp thunderbird
```

---

## Manual Installation (Both Methods)

### Modular (Manual):

```bash
# 1. Create directory
mkdir -p ~/.local/bin

# 2. Download script
curl -o ~/.local/bin/blauncher.sh https://raw.githubusercontent.com/mcqueentrading/blauncher/main/blauncher.sh
chmod +x ~/.local/bin/blauncher.sh

# 3. Add to bashrc
echo '[ -f "$HOME/.local/bin/blauncher.sh" ] && source "$HOME/.local/bin/blauncher.sh"' >> ~/.bashrc

# 4. Ensure ~/.local/bin is in PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# 5. Reload
source ~/.bashrc
```

### Inline (Manual):

```bash
# Download and append
curl -fsSL https://raw.githubusercontent.com/mcqueentrading/blauncher/main/blauncher.sh >> ~/.bashrc

# Reload
source ~/.bashrc
```

---

## Verification

Run this to verify installation:

```bash
# Check if functions exist
for func in oo op orp; do
    if type $func &>/dev/null; then
        echo "✓ $func is available"
    else
        echo "✗ $func is NOT available"
    fi
done

# Check if completion is registered
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

## Need Help?

- **Questions?** [Open an issue](https://github.com/mcqueentrading/blauncher/issues)
- **Bugs?** [Report here](https://github.com/mcqueentrading/blauncher/issues/new)
- **Documentation:** [README.md](README.md)

---

**Happy launching! 🚀**
