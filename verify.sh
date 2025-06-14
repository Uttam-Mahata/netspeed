#!/bin/bash

# NetSpeed Extension Verification Script

EXTENSION_UUID="netspeed@uttammahata.local"

echo "=== NetSpeed Extension Verification ==="
echo ""

echo "1. Checking if extension files exist..."
if [ -d "$HOME/.local/share/gnome-shell/extensions/$EXTENSION_UUID" ]; then
    echo "✓ Extension directory exists"
    echo "Files in extension directory:"
    ls -la "$HOME/.local/share/gnome-shell/extensions/$EXTENSION_UUID/"
else
    echo "✗ Extension directory not found"
    exit 1
fi

echo ""
echo "2. Checking if GNOME Shell recognizes the extension..."
if gnome-extensions list | grep -q "$EXTENSION_UUID"; then
    echo "✓ Extension is recognized by GNOME Shell"
    
    echo ""
    echo "3. Checking extension status..."
    if gnome-extensions info "$EXTENSION_UUID" | grep -q "State: ENABLED"; then
        echo "✓ Extension is ENABLED"
        echo ""
        echo "🎉 Success! The NetSpeed extension should be visible in your top panel."
        echo "Look for download (↓) and upload (↑) speed indicators."
    elif gnome-extensions info "$EXTENSION_UUID" | grep -q "State: DISABLED"; then
        echo "⚠ Extension is DISABLED"
        echo ""
        echo "To enable it, run:"
        echo "gnome-extensions enable $EXTENSION_UUID"
        echo ""
        echo "Or use the Extensions app (gnome-extensions-app)"
    else
        echo "? Extension state unknown"
        gnome-extensions info "$EXTENSION_UUID"
    fi
else
    echo "✗ Extension not recognized by GNOME Shell"
    echo ""
    echo "Troubleshooting steps:"
    echo "1. Make sure you've logged out and logged back in"
    echo "2. Check for errors in logs:"
    echo "   journalctl --user -f | grep gnome-shell"
    echo "3. Try restarting GNOME Shell (X11 only):"
    echo "   Alt+F2, type 'r', press Enter"
fi

echo ""
echo "=== All Extensions List ==="
gnome-extensions list
