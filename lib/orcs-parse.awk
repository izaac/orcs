#!/usr/bin/awk -f

# orcs-parse.awk
# Parses raw rc-status output into a simple, semicolon-separated format.
# It only extracts service, status, and runlevel.

BEGIN {
    # Set the field separator to a space.
    FS=" "
    # Initialize the runlevel.
    runlevel="sysinit"
}

# Match and update the current runlevel.
/^Runlevel:/ {
    runlevel=$2
    next
}
/^Dynamic Runlevel:/ {
    runlevel=$3
    next
}

# Match services from "rc-status --all" output (e.g., "sshd [ started ]").
$2 == "[" {
    printf "%s;%s;%s\n", $1, $3, runlevel
}

# Match services from "rc-status --unused" output (single-column names).
NF == 1 && !/^Runlevel/ && !/^Dynamic/ {
    printf "%s;disabled;disabled\n", $1
}
