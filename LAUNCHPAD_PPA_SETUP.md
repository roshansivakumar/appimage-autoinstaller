# Setting Up a Launchpad PPA

This guide will help you publish `appimage-autoinstaller` to a Launchpad PPA for easy installation via `apt`.

## Prerequisites

1. **Launchpad Account**: Create an account at https://launchpad.net
2. **GPG Key**: Required for signing packages
3. **SSH Key**: For uploading to Launchpad

## Step 1: Create and Configure GPG Key

```bash
# Generate GPG key if you don't have one
gpg --full-generate-key
# Choose: (1) RSA and RSA, 4096 bits, no expiration

# List your keys
gpg --list-keys

# Upload your public key to Ubuntu keyserver
gpg --send-keys YOUR_KEY_ID --keyserver keyserver.ubuntu.com
```

## Step 2: Create PPA on Launchpad

1. Go to https://launchpad.net/~your-username
2. Click "Create a new PPA"
3. Name: `appimage-autoinstaller`
4. Display name: `AppImage Auto-Installer`
5. Description: Add package description

## Step 3: Prepare Source Package

```bash
cd ~/Projects/appimage-autoinstaller

# Install packaging tools
sudo apt-get install devscripts debhelper dput

# Update debian/changelog with your details
dch -i

# Build source package (signed)
debuild -S -sa

# This creates:
# - appimage-autoinstaller_1.0.0.dsc
# - appimage-autoinstaller_1.0.0.tar.xz
# - appimage-autoinstaller_1.0.0_source.changes
# - appimage-autoinstaller_1.0.0_source.build
```

## Step 4: Configure dput

Create/edit `~/.dput.cf`:

```ini
[ppa]
fqdn = ppa.launchpad.net
method = ftp
incoming = ~roshansivakumar/ubuntu/appimage-autoinstaller/
login = anonymous
allow_unsigned_uploads = 0
```

## Step 5: Upload to PPA

```bash
cd ~/Projects

# Upload to PPA
dput ppa appimage-autoinstaller_1.0.0_source.changes

# Wait for email confirmation from Launchpad
# The package will be built for multiple Ubuntu versions
```

## Step 6: Update README

Once the PPA is active, update README.md to change "Coming Soon" to active instructions.

## Supported Ubuntu Versions

Configure in `debian/changelog` for each version:
- Ubuntu 24.04 LTS (Noble)
- Ubuntu 22.04 LTS (Jammy)
- Ubuntu 20.04 LTS (Focal)

## Building for Multiple Versions

```bash
# For each Ubuntu version
for release in focal jammy noble; do
    dch -D $release -l ~${release}1 "Build for $release"
    debuild -S -sa
    dput ppa appimage-autoinstaller_*${release}*_source.changes
done
```

## Troubleshooting

### GPG Key Not Found
```bash
gpg --send-keys YOUR_KEY_ID --keyserver keyserver.ubuntu.com
```

### Upload Rejected
- Ensure changelog version is higher than current PPA version
- Check GPG key is associated with your Launchpad account
- Verify package is signed correctly

### Build Failures
- Check build logs on Launchpad
- Ensure dependencies are available in Ubuntu repositories
- Test build locally with pbuilder

## Resources

- [Launchpad PPA Documentation](https://help.launchpad.net/Packaging/PPA)
- [Ubuntu Packaging Guide](https://packaging.ubuntu.com/html/)
- [Debian Maintainer Guide](https://www.debian.org/doc/manuals/maint-guide/)
