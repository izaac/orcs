#!/bin/sh

# install.sh
# An installer for the ORCS tool. It installs the project into a dedicated
# directory and creates a symbolic link for easy access.

set -e # Exit immediately if a command exits with a non-zero status.

# --- Configuration ---

# The base URL of the raw repository files.
# IMPORTANT: Replace this with your actual GitHub repository URL.
readonly SRC_URL="https://raw.githubusercontent.com/user/orcs/main"

# The directory where the project files will be stored.
readonly INSTALL_DIR="$HOME/.orcs"

# The directory where the executable's symlink will be placed.
readonly BIN_DIR="$HOME/.local/bin"

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
  # 1. Welcome and Security Warning
  color_bold "ORCS Installer"
  echo "This script will install the ORCS tool into: $INSTALL_DIR"
  echo "A symbolic link will be created at: $BIN_DIR/orcs"
  color_yellow "Warning: Always inspect scripts from the internet before running them."
  printf "Press Enter to continue, or Ctrl+C to cancel."
  read -r _

  # 2. Check for dependencies (curl or wget)
  if command -v curl >/dev/null 2>&1; then
    downloader="curl -fsSL"
  elif command -v wget >/dev/null 2>&1; then
    downloader="wget -qO-"
  else
    color_yellow "Error: You need either 'curl' or 'wget' to run this installer." >&2
    exit 1
  fi

  # 3. Create the installation directories
  printf "\nCreating installation directories...\n"
  mkdir -p "$INSTALL_DIR/bin"
  mkdir -p "$INSTALL_DIR/lib"
  mkdir -p "$BIN_DIR"

  # 4. Download all the necessary files
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

  # 5. Set execute permissions
  echo "Setting permissions..."
  chmod +x "${INSTALL_DIR}/bin/orcs"
  chmod +x "${INSTALL_DIR}/lib/orcs-parse.awk"
  chmod +x "${INSTALL_DIR}/lib/orcs-format.awk"

  # 6. Create the symbolic link
  echo "Creating symbolic link..."
  ln -sf "${INSTALL_DIR}/bin/orcs" "${BIN_DIR}/orcs"

  # 7. Check if the installation directory is in the user's PATH
  case ":$PATH:" in
  *":$BIN_DIR:"*)
    # PATH is correctly set
    ;;
  *)
    # PATH is not set, print a warning
    color_yellow "\nWarning: Your PATH does not seem to include $BIN_DIR."
    color_yellow "You will need to add it to your shell's configuration file (e.g., .bashrc, .zshrc):"
    color_bold "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    ;;
  esac

  # 8. Success!
  color_green "\n✅ ORCS has been successfully installed."
  echo "Run 'orcs --help' to get started."
}

# Run the main function
main
