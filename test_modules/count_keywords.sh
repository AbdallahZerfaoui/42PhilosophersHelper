#!/bin/bash

# Function to count keywords in a file based on the number of philosophers
count_keywords() {
    local TARGET_FILE=$1
	local nbr_philos=$2

    if [[ ! -f "$TARGET_FILE" ]]; then
        echo "Error: Target file '$TARGET_FILE' does not exist."
        return 1
    fi

    # for ((nbr_philos=MINI_PHILOS; nbr_philos<=MAX_PHILOS; nbr_philos+=STEP)); do
	# echo "Analyzing for nbr_philos=$nbr_philos..."

	# Count occurrences of each keyword
	local fork_count=$(grep -o "has taken a fork" "$TARGET_FILE" | wc -l)
	fork_count=$((fork_count / 2))  # Divide by 2 since each fork is taken twice
	local eating_count=$(grep -o "is eating" "$TARGET_FILE" | wc -l)
	local sleeping_count=$(grep -o "is sleeping" "$TARGET_FILE" | wc -l)
	local thinking_count=$(grep -o "is thinking" "$TARGET_FILE" | wc -l)
	# local max=$(echo -e "$fork\n$eating\n$sleeping\n$thinking" | sort -nr | head -1)
    # local min=$(echo -e "$fork\n$eating\n$sleeping\n$thinking" | sort -n | head -1)
	local sum=$((fork_count + eating_count + sleeping_count + thinking_count))

	# Difference between max and min
	local color="\033[0;31m"

    # Set color based on diff
    if [[ $sum -gt $((4 * NBR_MEALS * $nbr_philos)) && $fork_count -eq $eating_count ]]; then
        color="\033[0;32m"
    fi
	# Output the results
	# echo "Number of philosophers: $nbr_philos"
	echo -e "${color}has taken a fork   :     $fork_count${RESET}"
	echo -e "${color}is eating          : $eating_count${RESET}"
	echo -e "${color}is sleeping        : $sleeping_count${RESET}"
	echo -e "${color}is thinking        : $thinking_count${RESET}"
	echo -e "${color}-----------------------------${RESET}"
    # done
}

# Example usage of the function (comment or modify as needed)
# count_keywords 2 10 2 "philosopher_log.txt"

process_files() {
    local FILE_PREFIX="output"

    # Iterate through the range of files
	local nbr_philos=MINI_PHILOS
    for file in ${FILE_PREFIX}_*.txt; do
        # Check if the file matches the expected format
        if [[ $file =~ ${FILE_PREFIX}_[0-9]+_[0-9]+_[0-9]+_[0-9]+_[0-9]+\.txt ]]; then
            echo "Processing file: $file"
            count_keywords "$file" $nbr_philos
        else
            echo "Skipping unmatched file: $file"
        fi
		nbr_philos=$((nbr_philos + STEP))
    done
}