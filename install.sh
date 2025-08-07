#!/bin/sh

# install.sh
# A simple installer script for the ORCS tool.
# It downloads the necessary files from a remote repository.

set -e # Exit immediately if a command exits with a non-zero status.

# --- Configuration ---

# The location of the raw script files.
# IMPORTANT: Replace this URL with your actual GitHub repository URL.
SRC_URL="https://raw.githubusercontent.com/user/orcs/main"

# The directory to install the scripts into.
# $HOME/.local/bin is a standard location for user-specific executables.
INSTALL_DIR="$HOME/.local/bin"

# List of files required by the ORCS tool.
FILES="orcs orcs-parse.awk orcs-format.awk style.sh"

# Scripts that need to be made executable.
EXEC_FILES="orcs orcs-parse.awk orcs-format.awk"

# --- Helper Functions for Colorized Output ---

# These are self-contained and do not require style.sh
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
  color_yellow "Warning: Always inspect scripts from the internet before running them."
  printf "Press Enter to continue, or Ctrl+C to cancel."
  # SC3061 Fix: Provide a dummy variable for POSIX compliance.
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

  # 3. Create the installation directory if it doesn't exist
  # SC2028 Fix: Use printf for portable handling of '\n'.
  printf "\nEnsuring installation directory exists...\n"
  mkdir -p "$INSTALL_DIR"

  # 4. Download all the necessary files
  echo "Downloading ORCS files..."
  for file in $FILES; do
    printf "  - Downloading %s..." "$file"
    # Download the file from the source URL to the installation directory
    eval "$downloader" "${SRC_URL}/${file}" >"${INSTALL_DIR}/${file}"
    printf " done\n"
  done

  # 5. Set execute permissions on the required scripts
  echo "Setting permissions..."
  for file in $EXEC_FILES; do
    chmod +x "${INSTALL_DIR}/${file}"
  done

  # 6. Check if the installation directory is in the user's PATH
  case ":$PATH:" in
  *":$INSTALL_DIR:"*)
    # PATH is correctly set
    ;;
  *)
    # PATH is not set, print a warning
    color_yellow "\nWarning: Your PATH does not seem to include $INSTALL_DIR."
    color_yellow "You will need to add it to your shell's configuration file (e.g., .bashrc, .zshrc):"
    color_bold "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    ;;
  esac

  # 7. Success!
  color_green "\n✅ ORCS has been successfully installed."
  echo "Run 'orcs --help' to get started."
}

# Run the main function
main
