#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0" 2>/dev/null || echo "$0")")"

check_timestamps() 
{
    # Ensure the script is run with an argument (the executable path)
    if [ -z "$1" ]; then
        echo "Usage: ./run_philos.sh <path_to_philo_executable>"
        exit 1
    fi

    # Path to the executable
    EXECUTABLE=$1
	local nbr_errors=0
	rm -f output*
    # Loop through values of X (10 to 200, step 10)
    for ((nbr_philos=$MINI_PHILOS; nbr_philos<=$MAX_PHILOS; nbr_philos+=$STEP)); do
        echo "Running with $nbr_philos philosophers..."
		if [ $nbr_philos -lt 250 ]; then #TODO: change this if i did it when i thought that i may 
		#use a different number of meals for different number of philosophers.
        	python3 $SCRIPT_DIR/check_timestamps.py "$EXECUTABLE" "$nbr_philos" $TIME_TO_DIE $TIME_TO_EAT $TIME_TO_SLEEP $NBR_MEALS
			printf "${RESET}"
		else
			python3 $SCRIPT_DIR/check_timestamps.py "$EXECUTABLE" "$nbr_philos" $TIME_TO_DIE $TIME_TO_EAT $TIME_TO_SLEEP $NBR_MEALS
			printf "${RESET}"
		fi
		
        if [ $? -ne 0 ]; then
            echo "Test failed for $nbr_philos philosophers."
			# nbr_errors=$((nbr_errors+1))
            exit 1
        fi
    done
    #based on the number of errors, print the appropriate message
	# if [ $nbr_errors -ne 0 ]; then
	# 	printf "${GREEN}${BOLD}All tests passed!${RESET}\n"
	# 	exit 1
	# else
	# 	printf "${RED}${BOLD}Some tests failed!${RESET}\n"
	# fi
}

