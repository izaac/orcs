#!/usr/bin/awk -f

# orcs-decorate.awk
# This script reads a process list and a service list, and then
# enriches the service data with PIDs and color codes in a single pass.

BEGIN {
    FS=";";
    # A marker to separate the process list from the service list.
    proc_list_done = 0;
}

# 1. Process the first block of input (the process list).
!proc_list_done {
    # If we see the separator, switch to processing the service list.
    if ($0 == "---PROCESS_LIST_END---") {
        proc_list_done = 1;
        next;
    }

    # Store the entire process line, keyed by its line number.
    # This avoids parsing issues with complex command arguments.
    proc_lines[NR] = $0;
    next;
}

# 2. Process the second block of input (the service list).
proc_list_done {
    # Split the service line (e.g., "sshd;started;default")
    split($0, parts, ";");
    service = parts[1];
    status = parts[2];
    runlevel = parts[3];

    pid = "-";
    if (status == "started") {
        # Loop through the stored process list to find a match.
        for (i in proc_lines) {
            # Check if the service name appears in the process line.
            if (index(proc_lines[i], service) && !index(proc_lines[i], "awk") && !index(proc_lines[i], "orcs")) {
                # If a match is found, extract just the PID (the first field).
                split(proc_lines[i], proc_parts, " ", seps);
                pid = proc_parts[1];
                break;
            }
        }
    }

    # Add color codes and status symbols.
    status_text = YELLOW "⚠️ " status NC;
    if (status == "started") { status_text = GREEN "✅ " status NC; }
    if (status == "stopped") { status_text = RED "❌ " status NC; }
    if (status == "disabled") { status_text = YELLOW "🚫 " status NC; }

    # Print the final, fully-decorated line.
    printf "%s;%s;%s;%s\n", CYAN service NC, status_text, MAGENTA pid NC, BLUE runlevel NC;
}

