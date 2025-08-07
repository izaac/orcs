#!/usr/bin/awk -f

# orcs-format.awk
# This awk script formats semicolon-separated data into aligned columns.
# It dynamically calculates column widths and handles ANSI color codes.

BEGIN {
    FS=";";
    # Regex for ANSI color codes
    ansi_regex = "\x1b\\[[0-9;]*m";
}

# First pass: read all data into memory and calculate max visual column widths.
{
    for(i=1; i<=NF; i++) {
        # Store field data for the second pass.
        data[NR,i] = $i

        # Create a temporary string with ANSI codes removed for length calculation.
        temp_s = $i;
        gsub(ansi_regex, "", temp_s);

        # Update the max width for the column if this one is longer.
        if (length(temp_s) > max_w[i]) {
            max_w[i] = length(temp_s);
        }
    }
}

# Second pass: print all the formatted data.
END {
    for (line_num=1; line_num<=NR; line_num++) {
        # Construct and print the formatted line.
        for (col_num=1; col_num<=NF; col_num++) {
            # Manually calculate padding to correctly handle color codes.
            original_string = data[line_num,col_num];
            
            stripped_string = original_string;
            gsub(ansi_regex, "", stripped_string);
            
            visual_length = length(stripped_string);
            padding_needed = max_w[col_num] - visual_length;

            # Print the original colored string...
            printf "%s", original_string;
            # ...then print the exact number of padding spaces required.
            for (p=1; p<=padding_needed; p++) {
                printf " ";
            }

            # Print a separator between columns.
            if (col_num < NF) {
                printf "   ";
            }
        }
        printf "\n";

        # After printing the header (line 1), print the underline.
        if (line_num == 1) {
            total_width=0;
            for(i=1; i<=NF; i++) total_width += max_w[i];
            # Add width of separators: (NF-1) * 3 spaces
            total_width += (NF-1) * 3;
            
            underline = "";
            for(i=1; i<=total_width; i++) underline = underline "-";
            
            # Use color variables passed from the shell environment.
            printf "%s%s%s\n", ENVIRON["GREEN"], underline, ENVIRON["NC"];
        }
    }
}

