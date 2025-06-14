#!/bin/bash

# Enhanced installation script for NetSpeed Extension

EXTENSION_UUID="netspeed@uttammahata.local"
EXTENSION_DIR="$HOME/.local/share/gnome-shell/extensions/$EXTENSION_UUID"
CURRENT_DIR="$(pwd)"

echo "=== NetSpeed Extension Enhanced Installation ==="

# Step 1: Ensure GNOME Shell Extensions is available
if ! command -v gnome-extensions &> /dev/null; then
    echo "Error: gnome-extensions command not found. Please install gnome-shell-extensions."
    exit 1
fi

# Step 2: Create extension directory
echo "Creating extension directory..."
mkdir -p "$EXTENSION_DIR"

# Step 3: Copy files
echo "Copying extension files..."
cp "$CURRENT_DIR/metadata.json" "$EXTENSION_DIR/"
cp "$CURRENT_DIR/extension.js" "$EXTENSION_DIR/"
cp "$CURRENT_DIR/stylesheet.css" "$EXTENSION_DIR/"

# Step 4: Set proper permissions
echo "Setting permissions..."
chmod 644 "$EXTENSION_DIR"/*

# Step 5: Clear GNOME Shell cache
echo "Clearing GNOME Shell cache..."
rm -rf ~/.cache/gnome-shell/extensions 2>/dev/null || true

# Step 6: Check if extension is now visible
echo "Checking extension availability..."
sleep 2

if gnome-extensions list | grep -q "$EXTENSION_UUID"; then
    echo "✓ Extension found in system!"
    
    # Try to enable it
    if gnome-extensions enable "$EXTENSION_UUID" 2>/dev/null; then
        echo "✓ Extension enabled successfully!"
    else
        echo "⚠ Could not enable extension automatically."
    fi
else
    echo "⚠ Extension not yet visible to GNOME Shell."
    echo "This is normal on Wayland systems."
fi

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Extension files installed to: $EXTENSION_DIR"
echo ""
echo "Next steps:"
echo "1. Log out and log back in (required on Wayland)"
echo "2. Open Extensions app or run: gnome-extensions-app"
echo "3. Find 'Network Speed Monitor' and enable it"
echo ""
echo "Alternative: Try running these commands after logging back in:"
echo "   gnome-extensions list | grep netspeed"
echo "   gnome-extensions enable $EXTENSION_UUID"
echo ""
echo "If you still have issues, check the logs:"
echo "   journalctl --user -f | grep gnome-shell"
