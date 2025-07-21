#!/bin/bash

set -e

# Function to check and install a package if missing
install_if_missing() {
    local pkg="$1"
    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
        echo "[⬇] Installing missing dependency: $pkg"
        sudo apt-get update
        sudo apt-get install -y "$pkg"
    else
        echo "[✔] $pkg is already installed."
    fi
}

# Display the Script(Tool) info
echo "  ____by sudo-hope0529___       ______    _  "
echo " / __ \___  ___ ___  / _ \__ __/ _/ _/   (_) "
echo "/ /_/ / _ \/ -_) _ \/ ___/ // / _/ _/   / /  "
echo "\____/ .__/\__/_//_/_/   \_,_/_//_/    /_/   "
echo "    /_/ OpenPuff Auto Installer - Version 1.0"
echo ""
echo "OpenPuff Auto Installer - Version 1.0"
echo "Created & managed by sudo-hope0529"
echo "for more Visit: https://sudo-hope0529.github.io"
echo ""


# Install required dependencies
install_if_missing wget
install_if_missing unzip

# Installing & configuring wine 32-bit for openpuff
# Check if the script file exists
if [ -f "install_wine_4_openpuff.sh" ]; then
    echo "[*]Wine Installation & Config Script file exists. Running it..."
    sudo bash install_wine_4_openpuff.sh
else
    echo "[!] Wine Installation & Config Script file does not exist. Cloning from GitHub repository..>"
    git clone https://github.com/sudo-hope0529/Openpuff-Auto-Install-2025.git
    if [ $? -eq 0 ]; then  # Check if git clone succeeded
        cd Openpuff-Auto-Install-2025
        echo "[⬇] Installing and configuring Wine for Openpuff..."
        sudo bash install_wine_4_openpuff.sh
    else
        echo "[!] Failed to clone the repository..."
        echo "[*] Clone it from https://github.com/sudo-hope0529/Openpuff-Auto-Install-2025.git" 
        exit 1
    fi
fi


# Define paths for openpuff installation
INSTALL_DIR="/opt/openpuff"
BIN_PATH="/usr/local/bin/openpuff"
ZIP_PATH="/tmp/openpuff.zip"

# Remove previous installation (if any)
sudo rm -rf "$INSTALL_DIR"
sudo mkdir -p "$INSTALL_DIR"

# Download OpenPuff
echo "[⬇] Downloading OpenPuff..."
wget -O "$ZIP_PATH" http://embeddedsw.net/zip/OpenPuff_release.zip

# Extract OpenPuff
echo "[⬇] Extracting..."
sudo unzip "$ZIP_PATH" -d "$INSTALL_DIR"
rm "$ZIP_PATH"
echo "[✔] Extracted..."


# Create launcher
echo "[*] Creating launcher at $BIN_PATH..."
sudo tee "$BIN_PATH" > /dev/null << EOF
#!/bin/sh
wine "$INSTALL_DIR"/OpenPuff*/OpenPuff.exe "\$@"
EOF

# Make launcher executable
sudo chmod +x "$BIN_PATH"

echo "[✔] OpenPuff installed successfully!"
echo "[✔] Run it using the command: openpuff"
