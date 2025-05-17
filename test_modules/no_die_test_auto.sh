#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0" 2>/dev/null || echo "$0")")"

no_die_test_auto () 
{
	printf "\n${CYAN}=== Starting tests where a philosopher should NOT die ===\n${RESET}"
	read -r -p $'\nPlease enter desired timer for tests or press ENTER to use default '"$DEFAULT_TIMEOUT"' seconds: ' timeout
	printf "\n"
	if [[ $timeout != *[[:digit:]]* || $timeout -le 0 ]]; then
		timeout=$DEFAULT_TIMEOUT
	fi
	while IFS="" read -r -u 3 input || [ -n "$input" ] # read input from fd 3
	do
		read -r -u 3 result    # read desired result description from input.txt
		printf "\nTest: ${BLUEBG}${WHITE}[$input]${RESET} | ${PURP}$result${RESET}\n\n"
		"$SCRIPT_DIR/PhilosophersChecker.py" "$1 $input" $timeout > /dev/null & pid=$!   # silence checker output and run in bg
		local elapsed=0
		while ps -p $pid &>/dev/null; do    # check if checker script still running
			draw_progress_bar $elapsed $timeout "seconds" # TODO: fix extra space at end of progress bar, extra )
			if [[ $elapsed == $timeout ]]; then
				printf "\n\n${GREEN}OK${RESET}\n"
				(( PASS++ ))
				break;
			fi
			(( elapsed++ ))
			sleep 1
		done
		wait $pid
		status=$?
		if [[ $status != 0 ]]; then
			printf "\n\n${RED}KO${RESET} - program terminated prematurely\n"
			(( FAIL++ ))
		fi
		(( TESTS++ ))
	done 3< "$SCRIPT_DIR/data/no-die.txt"   # open file is assigned fd 3
	printf "\nNo-Die Tests: ${GREEN}PASSED${RESET}: $PASS/$TESTS | ${RED}FAILED${RESET}: $FAIL/$TESTS\n"
	exec 3<&-	# close fd 3
}