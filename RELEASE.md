# Release Process

## Creating a New Release

### 1. Update Version

```bash
# Update debian/changelog
dch -v 1.0.1 "New release with bug fixes"

# Update version in README if needed
```

### 2. Build Package

```bash
cd ~/Projects/appimage-autoinstaller

# Build binary package
dpkg-buildpackage -us -uc -b

# Package will be created in parent directory
ls -lh ../appimage-autoinstaller_*.deb
```

### 3. Test Package Locally

```bash
# Remove old version
sudo apt remove appimage-autoinstaller

# Install new version
sudo dpkg -i ../appimage-autoinstaller_1.0.1_all.deb

# Test functionality
appimage-sync
systemctl --user status appimage-installer.path
```

### 4. Commit and Tag

```bash
git add -A
git commit -m "Release v1.0.1"
git tag -a v1.0.1 -m "Version 1.0.1"
git push origin main --tags
```

### 5. Create GitHub Release

#### Via GitHub Web Interface
1. Go to https://github.com/roshansivakumar/appimage-autoinstaller/releases
2. Click "Draft a new release"
3. Choose tag: v1.0.1
4. Release title: v1.0.1
5. Add release notes
6. Upload `appimage-autoinstaller_1.0.1_all.deb`
7. Click "Publish release"

### 6. Update PPA (Optional)

```bash
# Build source package
debuild -S -sa

# Upload to PPA
dput ppa appimage-autoinstaller_1.0.1_source.changes
```

## Release Checklist

- [ ] Version bumped in debian/changelog
- [ ] README updated if needed
- [ ] Package builds successfully
- [ ] Package tested locally
- [ ] Changes committed and tagged
- [ ] GitHub release created with .deb file
- [ ] PPA updated (if applicable)
- [ ] Release announcement posted

## Version Numbering

Follow Semantic Versioning (semver.org):
- **MAJOR**: Breaking changes
- **MINOR**: New features, backwards compatible
- **PATCH**: Bug fixes, backwards compatible

Examples:
- 1.0.0 - Initial release
- 1.0.1 - Bug fix
- 1.1.0 - New feature
- 2.0.0 - Breaking change
