#!/bin/sh

# install.sh
# An installer for the ORCS tool. It installs the project into a system-wide
# location (/usr/local/lib) and creates a symbolic link in /usr/local/bin.

set -e # Exit immediately if a command exits with a non-zero status.

# --- Configuration ---

# The base URL of the raw repository files.
readonly SRC_URL="https://raw.githubusercontent.com/izaac/orcs/main"

# The system-wide directory where the project files will be stored.
readonly INSTALL_DIR="/usr/local/lib/orcs"

# The standard directory for user-installed executables.
readonly BIN_DIR="/usr/local/bin"

# --- Helper Functions for Colorized Output ---
color_green() {
  printf '\033[32m%s\033[0m\n' "$1"
}
color_yellow() {
  printf '\033[33m%s\033[0m\n' "$1"
}
color_bold() {
  printf '\033[1m%s\033[0m\n' "$1"
}

# --- Main Installation Logic ---

main() {
  # 1. Check for root privileges
  if [ "$(id -u)" -ne 0 ]; then
    color_yellow "Error: This installer must be run with sudo or as root." >&2
    echo "Please try again using: curl ... | sudo sh"
    exit 1
  fi

  # 2. Welcome and Security Warning
  color_bold "ORCS Installer (System-Wide)"
  echo "This script will install the ORCS tool into: $INSTALL_DIR"
  echo "A symbolic link will be created at: $BIN_DIR/orcs"
  color_yellow "Warning: Always inspect scripts from the internet before running them."
  printf "Press Enter to continue, or Ctrl+C to cancel."
  # Read from the terminal, not from the pipe.
  read -r _ </dev/tty

  # 3. Check for dependencies (curl or wget)
  if command -v curl >/dev/null 2>&1; then
    downloader="curl -fsSL"
  elif command -v wget >/dev/null 2>&1; then
    downloader="wget -qO-"
  else
    color_yellow "Error: You need either 'curl' or 'wget' to run this installer." >&2
    exit 1
  fi

  # 4. Create the installation directories
  printf "\nCreating installation directories...\n"
  mkdir -p "$INSTALL_DIR/bin"
  mkdir -p "$INSTALL_DIR/lib"
  mkdir -p "$BIN_DIR"

  # 5. Download all the necessary files
  echo "Downloading ORCS files..."
  # Download main executable
  printf "  - Downloading bin/orcs..."
  eval "$downloader" "${SRC_URL}/bin/orcs" >"${INSTALL_DIR}/bin/orcs"
  printf " done\n"

  # Download library files
  for file in orcs-parse.awk orcs-format.awk style.sh; do
    printf "  - Downloading lib/%s..." "$file"
    eval "$downloader" "${SRC_URL}/lib/${file}" >"${INSTALL_DIR}/lib/${file}"
    printf " done\n"
  done

  # 6. Set execute permissions
  echo "Setting permissions..."
  chmod +x "${INSTALL_DIR}/bin/orcs"
  chmod +x "${INSTALL_DIR}/lib/orcs-parse.awk"
  chmod +x "${INSTALL_DIR}/lib/orcs-format.awk"

  # 7. Create the symbolic link
  echo "Creating symbolic link..."
  ln -sf "${INSTALL_DIR}/bin/orcs" "${BIN_DIR}/orcs"

  # 8. Success!
  color_green "\n✅ ORCS has been successfully installed."
  echo "Run 'orcs --help' to get started. You can now use 'sudo orcs'."
}

# Run the main function
main
