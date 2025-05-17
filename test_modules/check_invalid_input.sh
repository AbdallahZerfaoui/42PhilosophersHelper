#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0" 2>/dev/null || echo "$0")")"

check_invalid_inputs()
{
    # Check if the input file exists
    if [[ ! -f "$SCRIPT_DIR/data/invalid_input.txt" ]]; then
        echo -e "${RED}Error: File ./data/invalid_input.txt not found.${RESET}"
        return 1
    fi

    # Check if the program executable is provided
    if [[ -z "$1" ]]; then
        echo -e "${RED}Error: No executable provided.${RESET}"
        return 1
    fi

    echo -e "${CYAN}=== Starting invalid input tests ===${RESET}"

    local passed=0
    local failed=0
	local total=0
    local line_number=0
    while IFS="" read -r line || [[ -n "$line" ]]; do
        # Increment line counter
        ((line_number++))

        # Skip odd-numbered lines
        if (( line_number % 2 != 1 )); then
            continue
        fi

        # Skip empty lines
        if [[ -z "$line" ]]; then
            continue
        fi

		# Run the program with the invalid input
		echo "Testing invalid input: $line"
		output=$($1 $line 2>&1)
		exit_code=$?
		# echo $output
		# Check the result: OK if the program exits with an error code but doesn't crash
		if [[ $exit_code -ne 0 && "$output" =~ [Ii][Nn][Vv][Aa][Ll][Ii][Dd] ]]; then
			echo -e "${GREEN}OK: Handled invalid input correctly.${RESET}"
			((passed++))
		else
			echo -e "${RED}KO: Program did not handle invalid input correctly.${RESET}"
			((failed++))
		fi
    done < "$SCRIPT_DIR/data/invalid_input.txt"
	total=$((passed+failed))
    echo -e "${CYAN}=== Invalid input tests completed ===${RESET}"
    echo -e "${GREEN}PASSED: ${passed}/${total} | ${RED}FAILED: ${failed}/${total}"
}