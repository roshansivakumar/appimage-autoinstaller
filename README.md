# AppImage Auto-Installer

Automatically monitor a directory for AppImage files and install them with full desktop integration.

## Features

- 🚀 **Automatic Installation** - Watches a directory and auto-installs AppImages when downloaded
- 🎯 **Smart Duplicate Detection** - Skips already-installed AppImages
- 🖼️ **Icon Extraction** - Automatically extracts and configures application icons
- 📝 **Desktop Integration** - Creates launcher entries for your application menu
- ⚡ **Zero Overhead** - systemd path units use no CPU while idle
- 🔧 **Configurable** - Choose your watch and install directories during setup
- 💻 **Manual Sync** - Run `appimage-sync` anytime to scan for new AppImages

## Installation

### From PPA (Recommended)

```bash
sudo add-apt-repository ppa:yourusername/appimage-autoinstaller
sudo apt update
sudo apt install appimage-autoinstaller
```

### From .deb Package

```bash
# Download the latest .deb from releases
wget https://github.com/yourusername/appimage-autoinstaller/releases/download/v1.0.0/appimage-autoinstaller_1.0.0_all.deb

# Install
sudo dpkg -i appimage-autoinstaller_1.0.0_all.deb
sudo apt-get install -f  # Fix any dependency issues
```

### Build from Source

```bash
git clone https://github.com/yourusername/appimage-autoinstaller.git
cd appimage-autoinstaller
dpkg-buildpackage -us -uc -b
sudo dpkg -i ../appimage-autoinstaller_1.0.0_all.deb
```

## Usage

### During Installation

You'll be prompted to configure:
1. **Watch Directory** - Where AppImages will be downloaded (e.g., `~/Downloads/Installers`)
2. **Install Directory** - Where AppImages will be installed (e.g., `/opt/appimages`)

### After Installation

**Automatic Mode:**
- Simply download or move `.AppImage` files to your configured watch directory
- The installer runs automatically within seconds
- AppImages are moved to the install directory and added to your application menu

**Manual Mode:**
```bash
appimage-sync
```
Scans the watch directory and installs any uninstalled AppImages.

### Check Status

```bash
# View systemd watcher status
systemctl --user status appimage-installer.path

# View recent installation logs
journalctl --user -u appimage-installer.service -n 50
```

## How It Works

1. **systemd Path Unit** monitors your watch directory for changes
2. **Installation Script** triggers when new files are detected
3. **Duplicate Check** ensures AppImages aren't installed twice
4. **Icon Extraction** uses `--appimage-extract` to get embedded icons and .desktop files
5. **Desktop Integration** creates launcher entries in `~/.local/share/applications`
6. **Zero Overhead** systemd uses inotify - no polling, no CPU usage while idle

## Configuration

Configuration is stored in `/etc/appimage-autoinstaller.conf`:

```bash
WATCH_DIR="/home/user/Downloads/Installers"
INSTALL_DIR="/opt/appimages"
```

To reconfigure:
```bash
sudo dpkg-reconfigure appimage-autoinstaller
```

## Uninstallation

```bash
# Remove package (keeps configuration)
sudo apt remove appimage-autoinstaller

# Completely remove including configuration
sudo apt purge appimage-autoinstaller
```

## Requirements

- **OS**: Ubuntu/Debian-based Linux distributions
- **Systemd**: For automatic monitoring
- **Bash**: 4.0 or higher

## Troubleshooting

### Service not running

```bash
systemctl --user enable appimage-installer.path
systemctl --user start appimage-installer.path
```

### AppImages not installing automatically

1. Check systemd status: `systemctl --user status appimage-installer.path`
2. Verify watch directory is correct: `cat /etc/appimage-autoinstaller.conf`
3. Check logs: `journalctl --user -u appimage-installer.service -n 50`
4. Ensure AppImage files have `.AppImage` extension

### Permission issues

Ensure the install directory is writable:
```bash
sudo chown -R $USER:$USER /opt/appimages
```

## Contributing

Contributions welcome! Please feel free to submit a Pull Request.

## License

MIT License - See LICENSE file for details

## Author

Created by Roshan

---

**Star this repo if you find it useful!** ⭐
