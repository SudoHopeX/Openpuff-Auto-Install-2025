!/bin/bash

set -e

echo "[*] Starting Wine installation and configuration for OpenPuff..."

# Ensure script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "[!] Please run this script with sudo:"
  echo "[!] sudo bash install_wine_for_openpuff.sh"
  exit 1
fi

# 1. Enable 32-bit architecture support
echo "[*] Enabling 32-bit architecture..."
dpkg --add-architecture i386
apt update

# 2. Install full Wine stack and dependencies
echo "[⬇] Installing Wine and all required components..."
apt install -y wine wine32 wine64 libwine libwine:i386 fonts-wine

# 3. Get the actual username to initialize Wine under the right user
USER_HOME=$(eval echo ~${SUDO_USER})
WINE_PREFIX="$USER_HOME/.wine"

# 4. Initialize a clean 32-bit Wine prefix
echo "[*] Setting up 32-bit Wine environment..."
sudo -u "$SUDO_USER" env WINEARCH=win32 WINEPREFIX="$WINE_PREFIX" wineboot

# Optional: Show winecfg GUI (commented out)
# sudo -u "$SUDO_USER" env WINEARCH=win32 WINEPREFIX="$WINE_PREFIX" winecfg

echo ""
echo "[✔]  Wine installation and 32-bit configuration complete!"
echo "[✔] You can now run 32-bit Windows apps like OpenPuff with the command: wine your_app.exe"
# echo "  Or just run: openpuff (if you've already installed OpenPuff CLI wrapper)"
