# Planned Improvements

## v1.1 / v2.0

### Better Configuration UX

**Problem:** Current debconf full-screen interface is overkill for 2 simple questions.

**Proposed Solutions:**

1. **Simple readline prompts** (preferred)
   - Use `read -p` in postinst for interactive terminals
   - Falls back to debconf for non-interactive/automated installs
   - Example:
     ```bash
     if [ -t 0 ]; then
         read -p "Watch directory [~/Downloads/Installers]: " WATCH_DIR
         read -p "Install directory [/opt/appimages]: " INSTALL_DIR
     else
         # Use debconf for automated/non-interactive
     fi
     ```

2. **Manual config file editing**
   - Create `/etc/appimage-autoinstaller.conf` during install
   - Include comments explaining each option
   - Users can edit directly without dpkg-reconfigure

3. **CLI configuration tool**
   - `appimage-autoinstaller --config` to change settings
   - Interactive prompts or flag-based: `--watch-dir=/path --install-dir=/path`

4. **Use readline frontend by default**
   - Set `DEBIAN_FRONTEND=readline` in postinst
   - At least avoids full-screen dialog

**Benefits:**
- Simpler user experience
- Faster configuration
- Less intimidating for new users
- Still maintains Debian packaging standards

**Target:** v1.1 (minor UX improvement) or v2.0 (major refactor)

---

## Other Future Improvements

- [ ] Support for custom icon extraction methods
- [ ] Uninstall command to remove specific AppImages
- [ ] List installed AppImages command
- [ ] Update detection for AppImages
- [ ] Logging of installation history
- [ ] Support for AppImage version management
