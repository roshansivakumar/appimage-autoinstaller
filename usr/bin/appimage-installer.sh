#!/usr/bin/env bash

# AppImage Auto-Installer Script
# Configurable via /etc/appimage-autoinstaller.conf

CONFIG_FILE="/etc/appimage-autoinstaller.conf"

# Load configuration
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file not found at $CONFIG_FILE"
    exit 1
fi

# Validate configuration
if [ -z "$WATCH_DIR" ] || [ -z "$INSTALL_DIR" ]; then
    echo "Error: WATCH_DIR and INSTALL_DIR must be set in $CONFIG_FILE"
    exit 1
fi

DESKTOP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons"

# Ensure directories exist
mkdir -p "$INSTALL_DIR" "$DESKTOP_DIR" "$ICON_DIR"

# Function to extract AppImage info and create desktop entry
install_appimage() {
    local appimage_path="$1"
    local filename=$(basename "$appimage_path")
    local appname="${filename%.AppImage}"
    local dest_path="$INSTALL_DIR/$filename"

    # Check if already installed
    if [ -f "$dest_path" ]; then
        echo "Already installed: $filename"
        return 0
    fi

    echo "Installing: $filename"

    # Make executable and move to install directory
    chmod +x "$appimage_path"
    mv "$appimage_path" "$dest_path"

    # Extract icon and desktop file from AppImage
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    "$dest_path" --appimage-extract *.desktop 2>/dev/null || true
    "$dest_path" --appimage-extract usr/share/icons 2>/dev/null || true
    "$dest_path" --appimage-extract .DirIcon 2>/dev/null || true

    # Find desktop file
    local desktop_file=$(find . -name "*.desktop" -type f 2>/dev/null | head -n 1)

    if [ -n "$desktop_file" ]; then
        # Copy and modify desktop file
        local desktop_name=$(basename "$desktop_file")
        cp "$desktop_file" "$DESKTOP_DIR/$desktop_name"

        # Update Exec path in desktop file
        sed -i "s|Exec=.*|Exec=$dest_path|g" "$DESKTOP_DIR/$desktop_name"

        # Find and copy icon
        local icon_file=$(find . -type f \( -name "*.png" -o -name "*.svg" \) 2>/dev/null | grep -E "(icon|logo|app)" | head -n 1)
        if [ -z "$icon_file" ]; then
            icon_file=$(find . -type f \( -name "*.png" -o -name "*.svg" \) 2>/dev/null | head -n 1)
        fi

        if [ -n "$icon_file" ]; then
            local icon_ext="${icon_file##*.}"
            local icon_name="${appname}_icon.$icon_ext"
            cp "$icon_file" "$ICON_DIR/$icon_name"
            sed -i "s|Icon=.*|Icon=$ICON_DIR/$icon_name|g" "$DESKTOP_DIR/$desktop_name"
        fi
    else
        # Create basic desktop file if extraction failed
        cat > "$DESKTOP_DIR/${appname}.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=$appname
Exec=$dest_path
Icon=application-x-executable
Categories=Utility;
Terminal=false
EOF
    fi

    # Clean up
    cd /
    rm -rf "$temp_dir"

    # Update desktop database
    update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true

    echo "✓ Installed: $filename"
}

# Scan watch directory for AppImages (both .AppImage and .appimage)
found=0
shopt -s nullglob  # Don't expand pattern if no matches
for appimage in "$WATCH_DIR"/*.AppImage "$WATCH_DIR"/*.appimage; do
    [ -f "$appimage" ] || continue
    install_appimage "$appimage"
    found=1
done
shopt -u nullglob  # Reset to default

if [ $found -eq 0 ]; then
    echo "No AppImages found in $WATCH_DIR"
else
    echo "AppImage installation check complete"
fi
