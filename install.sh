#!/bin/bash

# NetSpeed Extension Installation Script

EXTENSION_DIR="$HOME/.local/share/gnome-shell/extensions/netspeed@uttammahata.local"
CURRENT_DIR="$(pwd)"

echo "Installing NetSpeed Extension..."

# Create extension directory if it doesn't exist
mkdir -p "$EXTENSION_DIR"

# Copy files to extension directory
cp "$CURRENT_DIR/metadata.json" "$EXTENSION_DIR/"
cp "$CURRENT_DIR/extension.js" "$EXTENSION_DIR/"
cp "$CURRENT_DIR/stylesheet.css" "$EXTENSION_DIR/"

echo "Extension files copied to: $EXTENSION_DIR"

# Restart GNOME Shell (for X11)
if [ "$XDG_SESSION_TYPE" = "x11" ]; then
    echo "Restarting GNOME Shell (X11)..."
    gnome-shell --replace &
    disown
elif [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    echo "Wayland detected. Please log out and log back in to restart GNOME Shell."
fi

echo ""
echo "Installation complete!"
echo ""
echo "To enable the extension:"
echo "1. Open GNOME Extensions app or go to https://extensions.gnome.org/local/"
echo "2. Find 'Network Speed Monitor' in the list"
echo "3. Toggle it ON"
echo ""
echo "Alternatively, you can enable it via command line:"
echo "gnome-extensions enable netspeed@uttammahata.local"
