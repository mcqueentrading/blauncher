# blauncher Examples

This file contains practical examples of using blauncher in various scenarios.

## Basic Usage

### Launch Firefox
```bash
oo firefox
```
Launches Firefox and exits the shell.

### Open File Manager in Specific Directory
```bash
oo nemo ~/Downloads
op thunar /var/log
orp dolphin /media/usb
```

### Open Files with Default Application
```bash
oo xdg-open document.pdf
op evince report.pdf
```

## Media Applications

### Video Player
```bash
# Single video
oo vlc ~/Videos/movie.mp4

# Loop video
oo mpv --loop-file video.mp4

# Playlist
op mpv --playlist=playlist.m3u
```

### Music Player
```bash
oo spotify
oo rhythmbox ~/Music
op audacious --play
```

### Image Viewer
```bash
oo eog image.png
oo feh --scale-down photo.jpg
op gwenview ~/Pictures
```

## Development Tools

### Code Editors
```bash
# VS Code in current directory
op code .

# Specific project
oo code ~/projects/my-app

# Open specific file
op gedit config.txt
```

### Web Browsers for Development
```bash
# Open developer tools
oo firefox --devtools

# Chrome with specific profile
op google-chrome --profile-directory="Profile 1"

# Chromium in app mode
oo chromium --app=http://localhost:3000
```

### Terminal Emulators
```bash
# New terminal in specific directory
oo kitty --directory ~/projects

# GNOME Terminal with custom title
op gnome-terminal --title="Build Server" --working-directory=/var/log
```

## Office Applications

### Document Editors
```bash
oo libreoffice --writer document.odt
op abiword letter.doc
orp openoffice4 spreadsheet.ods
```

### PDF Tools
```bash
oo okular document.pdf
op evince --page-label=5 manual.pdf
```

## Communication

### Email Clients
```bash
orp thunderbird
oop evolution
```

### Messaging
```bash
oo slack
op discord
orp element-desktop
```

## Graphics & Design

### Image Editors
```bash
oo gimp photo.jpg
op krita drawing.kra
oop inkscape vector.svg
```

### 3D Software
```bash
oo blender project.blend
```

## System Tools

### File Managers
```bash
# Different file managers
oo nemo
op thunar
orp dolphin

# Admin mode
oo pkexec nemo /etc
```

### System Monitors
```bash
oo gnome-system-monitor
op htop
```

## Gaming

### Steam
```bash
orp steam
oo steam steam://rungameid/123456
```

### Native Games
```bash
oo minecraft-launcher
op lutris
```

## Automation & Scripting

### Launch Multiple Apps
```bash
#!/bin/bash
# startup.sh - Launch all work apps

oo firefox &
oo slack &
oo thunderbird &
op code ~/projects &
op spotify &

echo "Work environment launched!"
```

### Conditional Launches
```bash
# Launch browser only if not running
if ! pgrep -x firefox > /dev/null; then
    oo firefox
fi
```

### Launch with Specific Environment
```bash
# Run with custom environment variable
oo env LANG=ja_JP.UTF-8 firefox

# Use specific GPU
op DRI_PRIME=1 glxgears
```

## Advanced Examples

### Launch App and Open Specific URL
```bash
oo firefox "https://github.com/mcqueentrading/blauncher"
op chromium "http://localhost:8080"
```

### File Manager with Pre-selected File
```bash
oo nemo --select ~/Downloads/file.zip
```

### App with Multiple Arguments
```bash
oo mpv --volume=50 --loop-file --fullscreen video.mp4
```

### Launch with Sudo/Pkexec
```bash
oo pkexec gparted
op sudo -E wireshark
```

### Custom Script Launch
```bash
# Create a wrapper script
cat > ~/bin/dev-env << 'EOF'
#!/bin/bash
code ~/projects &
firefox http://localhost:3000 &
kitty --directory ~/projects &
EOF

chmod +x ~/bin/dev-env

# Launch it
oo dev-env
```

## Tab Completion Examples

### Command Completion
```bash
oo fire<TAB>           # Completes to: oo firefox
op code<TAB>           # Shows: code, codium, etc.
```

### Path Completion
```bash
oo nemo ~/Doc<TAB>             # Completes to: oo nemo ~/Documents/
op vlc ~/Videos/<TAB>          # Shows files in ~/Videos/
orp spotify ~/.config/<TAB>    # Shows directory contents
```

### Complex Path with Spaces
```bash
oo nemo ~/My\ Doc<TAB>         # Handles escaped spaces
oo nemo "~/My Doc<TAB>"        # Or use quotes
```

## Integration with Aliases

### Create Shortcuts
```bash
# Add to ~/.bashrc
alias browser='oo firefox'
alias files='oo nemo'
alias editor='op code'
alias music='oo spotify'
alias mail='orp thunderbird'

# Usage
browser
files ~/Downloads
editor .
```

### Function Wrappers
```bash
# Quick project launcher
project() {
    local name="$1"
    local dir="$HOME/projects/$name"
    
    if [ -d "$dir" ]; then
        op code "$dir"
        oo kitty --directory "$dir"
    else
        echo "Project $name not found"
    fi
}

# Usage
project my-app
```

## Troubleshooting Examples

### Debug Process Launch
```bash
# See if process actually started
op firefox
# Output: orphan, no child (12345)

# Check if still running
ps -p 12345
kill -0 12345 && echo "Running" || echo "Not running"
```

### Check Detachment
```bash
# Verify process is orphaned (PPID should be 1 or small)
op firefox
ps -o pid,ppid,cmd -p 12345
```

### Test with Simple Commands
```bash
# Use 'sleep' to test process handling
op sleep 60
# Process should continue even if you close terminal
```

---

## Tips

1. **Use `op` for debugging** - It keeps the shell open so you can see if there are issues
2. **Use `oo` for quick launches** - When you just want to open something and move on
3. **Use `orp` for critical apps** - Like email clients or servers that should never die
4. **Quote paths with spaces** - `oo app "~/My Documents/file.txt"`
5. **Combine with aliases** - Create your own shortcuts for frequently used apps

For more information, see the [README](README.md).
