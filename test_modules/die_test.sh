#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0" 2>/dev/null || echo "$0")")"

die_test () 
{
	printf "\n${CYAN}=== Starting tests where program should end with death or enough eaten ===\n${RESET}"
	while IFS="" read -r -u 3 input || [ -n "$input" ]	# read input from fd 3
	do
		read -r -u 3 result	# read desired result description from input.txt
		printf "\nTest: ${BLUEBG}${WHITE}[$input]${RESET} | ${PURP}$result${RESET}\n\n"	
		read -rs -n 1 -p $'Press ENTER to start test, press any other key to exit tester...\n' key  # read from stdin, accepting only 1 char
		if [[ $key == "" ]] ; then
			printf "\n"
			$1 $input	# run ./philo with test case input
		else
			exit 0
		fi
	done 3< "$SCRIPT_DIR/data/yes-die.txt"  # open file is assigned fd 3
	exec 3<&-	# close fd 3
}