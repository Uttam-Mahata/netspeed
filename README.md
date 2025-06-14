# Network Speed Monitor - GNOME Shell Extension

A simple and lightweight GNOME Shell extension that displays real-time internet download and upload speeds in the Ubuntu top panel.

## Features

- **Real-time monitoring**: Updates network speed every second
- **Clean interface**: Shows download (↓) and upload (↑) speeds with appropriate units
- **Automatic formatting**: Displays speeds in B/s, KB/s, MB/s, or GB/s as appropriate
- **Lightweight**: Minimal resource usage
- **All interfaces**: Monitors all network interfaces except loopback

## Installation

1. **Clone or download** this repository to your desired location
2. **Run the installation script**:
   ```bash
   ./install.sh
   ```
3. **Enable the extension**:
   - Open GNOME Extensions app (install with `sudo apt install gnome-shell-extension-manager` if needed)
   - Find "Network Speed Monitor" and toggle it ON
   
   Or use command line:
   ```bash
   gnome-extensions enable netspeed@uttammahata.local
   ```

## Manual Installation

If you prefer to install manually:

1. Create the extension directory:
   ```bash
   mkdir -p ~/.local/share/gnome-shell/extensions/netspeed@uttammahata.local
   ```

2. Copy the files:
   ```bash
   cp metadata.json extension.js stylesheet.css ~/.local/share/gnome-shell/extensions/netspeed@uttammahata.local/
   ```

3. Restart GNOME Shell:
   - **X11**: Press `Alt + F2`, type `r`, and press Enter
   - **Wayland**: Log out and log back in

4. Enable the extension using GNOME Extensions app or command line

## Uninstallation

To remove the extension:

1. Disable it first:
   ```bash
   gnome-extensions disable netspeed@uttammahata.local
   ```

2. Remove the extension directory:
   ```bash
   rm -rf ~/.local/share/gnome-shell/extensions/netspeed@uttammahata.local
   ```

## Compatibility

This extension is compatible with GNOME Shell versions 40-46, which covers:
- Ubuntu 21.04 and later
- Fedora 34 and later
- Most recent Linux distributions with GNOME

## Troubleshooting

### Extension not showing up
- Make sure you've restarted GNOME Shell after installation
- Check if the extension is installed: `gnome-extensions list | grep netspeed`

### No network data showing
- The extension reads from `/proc/net/dev` - ensure this file is accessible
- Check system logs: `journalctl -f | grep netspeed`

### Permission issues
- Make sure the install script is executable: `chmod +x install.sh`
- Ensure you have write permissions to `~/.local/share/gnome-shell/extensions/`

## Customization

You can modify the appearance by editing `stylesheet.css`:
- Change font size, color, or styling of the speed indicators
- Adjust margins and padding
- Add custom hover effects

## Contributing

Feel free to submit issues, feature requests, or pull requests to improve this extension.

## License

This project is open source and available under the MIT License.
