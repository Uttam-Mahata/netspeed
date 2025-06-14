import GObject from 'gi://GObject';
import St from 'gi://St';
import Clutter from 'gi://Clutter';
import GLib from 'gi://GLib';
import Gio from 'gi://Gio';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';

const NetSpeedIndicator = GObject.registerClass(
class NetSpeedIndicator extends PanelMenu.Button {
    _init() {
        super._init(0.0, 'Network Speed Monitor');

        // Create the main container
        this._box = new St.BoxLayout({
            style_class: 'panel-status-menu-box',
            vertical: false
        });

        // Create labels for download and upload speeds
        this._downloadLabel = new St.Label({
            text: '↓ 0 KB/s',
            style_class: 'netspeed-label',
            y_align: Clutter.ActorAlign.CENTER
        });

        this._uploadLabel = new St.Label({
            text: '↑ 0 KB/s',
            style_class: 'netspeed-label',
            y_align: Clutter.ActorAlign.CENTER
        });

        // Add labels to the box
        this._box.add_child(this._downloadLabel);
        this._box.add_child(new St.Label({ text: ' ', y_align: Clutter.ActorAlign.CENTER }));
        this._box.add_child(this._uploadLabel);

        this.add_child(this._box);

        // Initialize network statistics
        this._lastRxBytes = 0;
        this._lastTxBytes = 0;
        this._lastTime = GLib.get_monotonic_time();

        // Start monitoring
        this._updateId = null;
        this._startMonitoring();
    }

    _startMonitoring() {
        this._updateNetworkStats();
        this._updateId = GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 1, () => {
            this._updateNetworkStats();
            return GLib.SOURCE_CONTINUE;
        });
    }

    _stopMonitoring() {
        if (this._updateId) {
            GLib.source_remove(this._updateId);
            this._updateId = null;
        }
    }

    _updateNetworkStats() {
        try {
            // Read network statistics from /proc/net/dev
            const file = Gio.File.new_for_path('/proc/net/dev');
            const [success, contents] = file.load_contents(null);
            
            if (!success) {
                return;
            }

            const data = new TextDecoder().decode(contents);
            const lines = data.split('\n');
            
            let totalRxBytes = 0;
            let totalTxBytes = 0;

            // Parse network interfaces (skip header lines)
            for (let i = 2; i < lines.length; i++) {
                const line = lines[i].trim();
                if (!line) continue;

                const parts = line.split(/\s+/);
                const interface_name = parts[0].replace(':', '');
                
                // Skip loopback interface
                if (interface_name === 'lo') continue;

                const rxBytes = parseInt(parts[1]) || 0;
                const txBytes = parseInt(parts[9]) || 0;

                totalRxBytes += rxBytes;
                totalTxBytes += txBytes;
            }

            const currentTime = GLib.get_monotonic_time();
            const timeDiff = (currentTime - this._lastTime) / 1000000; // Convert to seconds

            if (this._lastRxBytes > 0 && timeDiff > 0) {
                const downloadSpeed = (totalRxBytes - this._lastRxBytes) / timeDiff;
                const uploadSpeed = (totalTxBytes - this._lastTxBytes) / timeDiff;

                this._downloadLabel.set_text(`↓ ${this._formatSpeed(downloadSpeed)}`);
                this._uploadLabel.set_text(`↑ ${this._formatSpeed(uploadSpeed)}`);
            }

            this._lastRxBytes = totalRxBytes;
            this._lastTxBytes = totalTxBytes;
            this._lastTime = currentTime;

        } catch (error) {
            log(`NetSpeed error: ${error.message}`);
        }
    }

    _formatSpeed(bytesPerSecond) {
        if (bytesPerSecond < 1024) {
            return `${Math.round(bytesPerSecond)} B/s`;
        } else if (bytesPerSecond < 1024 * 1024) {
            return `${Math.round(bytesPerSecond / 1024)} KB/s`;
        } else if (bytesPerSecond < 1024 * 1024 * 1024) {
            return `${(bytesPerSecond / (1024 * 1024)).toFixed(1)} MB/s`;
        } else {
            return `${(bytesPerSecond / (1024 * 1024 * 1024)).toFixed(1)} GB/s`;
        }
    }

    destroy() {
        this._stopMonitoring();
        super.destroy();
    }
});

export default class NetSpeedExtension {
    constructor() {
        this._indicator = null;
    }

    enable() {
        log('NetSpeed extension enabled');
        this._indicator = new NetSpeedIndicator();
        Main.panel.addToStatusArea('netspeed', this._indicator, 1, 'right');
    }

    disable() {
        log('NetSpeed extension disabled');
        if (this._indicator) {
            this._indicator.destroy();
            this._indicator = null;
        }
    }
}
