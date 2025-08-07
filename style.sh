# style.sh
# This script defines functions for colored and formatted terminal output.
# It uses tput for portability

# Define text colors
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
export BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE

# Define text styles
BOLD=$(tput bold)
RESET=$(tput sgr0)
NC="$RESET" # Alias for No Color
export BOLD RESET NC

# Function to print a message with a specific color
print_red() {
  printf "%s%s%s\n" "${RED}" "$1" "${NC}"
}

print_green() {
  printf "%s%s%s\n" "${GREEN}" "$1" "${NC}"
}

print_yellow() {
  printf "%s%s%s\n" "${YELLOW}" "$1" "${NC}"
}

# Common messages
print_error() {
  printf "%s%s%s\n" "${RED}" "$1" "${NC}" >&2
}

print_info() {
  printf "%s%s%s\n" "${GREEN}" "$1" "${NC}"
}

print_warning() {
  printf "%s%s%s\n" "${YELLOW}" "$1" "${NC}"
}
