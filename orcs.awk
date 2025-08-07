#!/usr/bin/awk -f

# orcs.awk
# This is a self-contained awk script for parsing OpenRC status output.

BEGIN {
    runlevel="sysinit"
}
# Match Runlevel headers to track the current runlevel
/^Runlevel:/ {
    runlevel=$2
    next
}
/^Dynamic Runlevel:/ {
    runlevel=$3
    next
}
# Match services from rc-status --all
$2 == "[" {
    service_name=$1
    status=$3
    
    # Skip services that don'\''t have a meaningful PID to display
    if (service_name == "acpid" || service_name == "local") {
        next
    }

    # Filter services based on view_flag
    if (view_flag == "active" && status != "started") {
        next
    }
    if (view_flag == "inactive" && status == "started") {
        next
    }
    
    # Find PID using a system command.
    pid_output = ""
    cmd = "sudo pgrep -f -x " service_name
    if (system(cmd " > /dev/null") == 0) {
        cmd | getline pid_output
        pid = pid_output
    } else {
        pid = "-"
    }
    close(cmd)

    # Choose colors and symbols based on status for better readability
    status_text = YELLOW "⚠️ " status NC
    if (status == "started") {
        status_text = GREEN "✅ " status NC
    } else if (status == "stopped") {
        status_text = RED "❌ " status NC
    } else if (status == "disabled") {
        status_text = YELLOW "🚫 " status NC
    }
    
    printf "%s;%s;%s;%s\n", CYAN service_name NC, status_text, MAGENTA pid NC, BLUE runlevel NC
}

# Match services from rc-status --unused
NF == 1 && $1 != "" && $1 !~ /^Runlevel/ && $1 !~ /^Dynamic Runlevel/ {
    service_name=$1
    status="disabled"
    pid="-"
    runlevel="disabled"

    # Skip services that don't have a meaningful PID to display
    if (service_name == "acpid" || service_name == "local") {
        next
    }

    # Filter services based on view_flag
    if (view_flag == "active" || view_flag == "inactive") {
        # Only show if view_flag is inactive or all
        if (view_flag != "inactive" && view_flag != "all") {
            next
        }
    }
    
    status_text = YELLOW "🚫 " status NC
    
    printf "%s;%s;%s;%s\n", CYAN service_name NC, status_text, MAGENTA pid NC, BLUE runlevel NC
}

