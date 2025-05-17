#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0" 2>/dev/null || echo "$0")")"

# Function to generate a smoothly changing color from red → yellow → green
get_color_code() {
    local percent=$1
    local red=255
    local green=0

    if [ "$percent" -lt 50 ]; then
        # Transition from red (255,0,0) to yellow (255,255,0)
        green=$((percent * 255 / 50))
    else
        # Transition from yellow (255,255,0) to green (0,255,0)
        red=$(((100 - percent) * 255 / 50))
        green=255
    fi

    printf "\033[38;2;%d;%d;0m" "$red" "$green"  # Generate ANSI 24-bit color code
}

# Function to display a smooth color transition progress bar
draw_progress_bar() {
    local progress=$1
    local total=$2
    local width=40  # Progress bar width
    local percent=$((progress * 100 / total))
	# printf "total: $total, progress: $progress, percent: $percent\n"
    # Get smooth transition color
    local color_code
    color_code=$(get_color_code "$percent")

    # Calculate number of filled blocks
    local num_fill=$((progress * width / total))
    local num_empty=$((width - num_fill))

    # Construct progress bar
    printf "\r["  
    for ((i = 0; i < num_fill; i++)); do 
        printf "%s#" "$(get_color_code "$percent")"  # Apply color to each #
    done
    printf "\033[0m"  # Reset color after filled blocks 

    for ((i = 0; i < num_empty; i++)); do 
        printf " "  # Empty spaces
    done

    printf "] %3d%%\033[0m" "$percent"
}

die_test_auto () {
    printf "\n${CYAN}=== Starting tests where program should end with death or enough eaten ===\n${RESET}"

    local total_tests=$(wc -l < "$SCRIPT_DIR/data/yes-die.txt")
    local completed_tests=0
    local test_timeout=10  # Max time for a single test

	total_tests=$((total_tests / 2))

    while IFS="" read -r -u 3 input || [ -n "$input" ]; do
        read -r -u 3 result  # Read expected result description
        printf "\nTest: ${BLUEBG}${WHITE}[$input]${RESET} | ${PURP}$result${RESET}\n\n"

        for i in $(seq 1 "$MAX_RETRIES"); do
            # Run the program in the background, suppressing all output
            temp_output=$(mktemp)
            ( "$1" $input >"$temp_output" 2>&1 ) &
            cmd_pid=$!

            # Start a watchdog timer and disown it (no "Terminated" messages)
            ( sleep "$test_timeout" && kill -9 "$cmd_pid" &>/dev/null ) & watchdog_pid=$!
            disown "$watchdog_pid" 2>/dev/null  # Prevent shell from tracking it

            wait "$cmd_pid" 2>/dev/null
            kill "$watchdog_pid" &>/dev/null  # Kill watchdog if process finished early

            # Get last line of output
            last_line=$(tail -n 1 "$temp_output")
            rm -f "$temp_output"  # Clean up temp file

            # Check if "died" is in the last line
            if ! echo "$last_line" | grep -q "died"; then
                printf "${RED}KO${RESET} - 'died' not found in the last line\n"
                break
            fi
        done

        if [ "$i" -eq "$MAX_RETRIES" ]; then
            printf "${GREEN}OK${RESET}\n"
        fi

        # Update progress
        ((completed_tests++))
        draw_progress_bar "$completed_tests" "$total_tests"

        # Prevent infinite loop
        if [ "$completed_tests" -ge "$total_tests" ]; then
            break
        fi
    done 3< "$SCRIPT_DIR/data/yes-die.txt"

    exec 3<&- # Close file descriptor
    printf "\n"  # Ensure newline after progress bar
}
