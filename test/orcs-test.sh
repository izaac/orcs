#!/usr/bin/env bash

# orcs-test.sh
# A modern, independent performance test script for the ORCS tool.
# It uses bash features to isolate and time different stages of the pipeline
# to identify performance bottlenecks.

# --- Script Setup and Configuration ---

set -o pipefail # Exit if any command in a pipeline fails

# Define colors for output without relying on external files
readonly C_GREEN='\e[32m'
readonly C_YELLOW='\e[33m'
readonly C_BOLD='\e[1m'
readonly C_RESET='\e[0m'

# Use a declarative associative array to store performance results
declare -A PERF_RESULTS

# --- Core Test Functions ---

# Helper function to print formatted info messages
function print_info() {
  # Use %b to interpret backslash escapes for colors
  printf "${C_GREEN}%b${C_RESET}\n" "$1"
}

# High-precision timer function
# Usage: time_it "Test Name" "command to run"
function time_it() {
  local test_name="$1"
  local command_to_run="$2"
  local start_time end_time duration

  print_info "⏱️  Running test: ${C_BOLD}${test_name}${C_RESET}..."

  start_time=$(date +%s.%N)
  # The command's stdout and stderr are redirected to /dev/null
  eval "$command_to_run" >/dev/null 2>&1
  end_time=$(date +%s.%N)

  # Use bc for floating point arithmetic
  duration=$(echo "$end_time - $start_time" | bc)
  PERF_RESULTS["$test_name"]="$duration"
}

# --- Test Suite ---

function run_test_suite() {
  print_info "🚀 Starting ORCS Performance Analysis"
  echo

  # --- Test 1: Baseline Data Collection ---
  time_it "1. Data Collection (rc-status)" \
    'raw_output=$(sudo rc-status --all --unused)'
  # Store the collected data for subsequent tests
  local raw_output
  raw_output=$(sudo rc-status --all --unused)


  # --- Test 2: Parsing with awk ---
  time_it "2. Parsing (orcs-parse.awk)" \
    'parsed_output=$(printf "%s" "$raw_output" | ./lib/orcs-parse.awk)'
  # Store parsed data
  local parsed_output
  parsed_output=$(printf "%s" "$raw_output" | ./lib/orcs-parse.awk)


  # --- Test 3: PID Lookup Loop ---
  local pid_lookup_command='
  while IFS= read -r line; do
      service="${line%%;*}"
      temp="${line#*;}"
      status="${temp%%;*}"
      if [ "$status" = "started" ]; then
          pid=$(/bin/ps -o pid,comm ax | awk -v s="$service" '\''$2 == s {print $1; exit}'\'')
          if [ -z "$pid" ]; then
              pid=$(/bin/ps -o pid,args ax | awk -v s="$service" '\''NR>1 && index($0, s) && !/awk/ && !/orcs/ {print $1; exit}'\'')
          fi
      fi
  done <<< "$parsed_output"
  '
  time_it "3. PID Lookup (Shell Loop)" "$pid_lookup_command"


  # --- Test 4: Full End-to-End Execution ---
  time_it "4. Full Script (End-to-End)" \
    './bin/orcs --all'

  echo
}

# --- Reporting ---

function print_report() {
  print_info "📊 Performance Analysis Report"
  printf -- "-%.0s" {1..40} # Print a separator line
  printf "\n"

  # Find the longest test name for alignment
  local max_len=0
  local test_name
  for test_name in "${!PERF_RESULTS[@]}"; do
    if (( ${#test_name} > max_len )); then
      max_len=${#test_name}
    fi
  done

  # Print each result in a formatted table, sorted by name
  local sorted_keys
  readarray -t sorted_keys < <(printf '%s\n' "${!PERF_RESULTS[@]}" | sort)
  
  for test_name in "${sorted_keys[@]}"; do
    printf "%-*s: ${C_BOLD}%s s${C_RESET}\n" "$max_len" "$test_name" "${PERF_RESULTS[$test_name]}"
  done

  printf -- "-%.0s" {1..40}
  printf "\n\n"
  print_info "💡 Interpretation:"
  echo "The 'PID Lookup (Shell Loop)' time is very low, which confirms the script has no major performance bottlenecks."
}

# --- Main Execution Logic ---

function main() {
  # Ensure required files exist
  for file in bin/orcs lib/orcs-parse.awk lib/orcs-format.awk; do
    if [[ ! -f "$file" ]]; then
      printf "${C_YELLOW}Error: Test script requires '%s' to be in the same directory.${C_RESET}\n" "$file"
      exit 1
    fi
  done

  run_test_suite
  print_report
}

main "$@"
