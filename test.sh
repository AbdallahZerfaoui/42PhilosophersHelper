#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0" 2>/dev/null || echo "$0")")"

source "$SCRIPT_DIR/load_scripts.sh"
source "$SCRIPT_DIR/setup/colors.sh"
source "$SCRIPT_DIR/setup/constants.sh"

# Define directories
TEST_MODULES_DIR="$SCRIPT_DIR/test_modules"
DATA_DIR="$SCRIPT_DIR/data"

# Source all .sh files in test_modules directory
for script in "$TEST_MODULES_DIR"/*.sh; do
    [ -f "$script" ] && source "$script"
done

# Load all .txt files from data directory (e.g., for reading reference values)
find "$DATA_DIR" -type f -name "*.txt" | while read -r data_file; do
#    echo "Loading data file: $data_file" 2>/dev/null
    cat "$data_file" >/dev/null  # Dummy read operation
done

# Source every other file in the script's directory (except itself)
for file in "$SCRIPT_DIR"/*.sh; do
    [ -f "$file" ] && [ "$file" != "$0" ] && source "$file" 2>/dev/null
done

# Counters
PASS=0
FAIL=0
TESTS=0

# Default project path is the parent directory
PROJECT_PATH=${1:-$(pwd)}

# Spinner function to show an animated progress indicator during compilation
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while kill -0 $pid 2>/dev/null; do
        for (( i=0; i<${#spinstr}; i++ )); do
            printf "\rCompiling... [${spinstr:$i:1}]"
            sleep $delay
        done
    done
    printf "\rCompilation complete!    \n"
}

# Ensure the provided path exists
if [ ! -d "$PROJECT_PATH" ]; then
    printf "${RED}Error: Provided path '$PROJECT_PATH' does not exist or is not a directory.${RESET}\n"
    exit 1
fi

# Clean up any previously copied executables in the tester directory
rm -f ./philo ./philo_bonus

# Compile the project in the given path while suppressing Makefile output
printf "Compiling the project...\n"
(
  cd "$PROJECT_PATH" && \
  make all > /dev/null 2>&1 && \
  make bonus > /dev/null 2>&1 && \
  make clean > /dev/null 2>&1
) &
compile_pid=$!
spinner $compile_pid

# Move the executables from the project directory (if they exist) to the tester directory
if [ -f "$PROJECT_PATH/philo" ]; then
    mv "$PROJECT_PATH/philo" ./ 2>/dev/null
fi
if [ -f "$PROJECT_PATH/philo_bonus" ]; then
    mv "$PROJECT_PATH/philo_bonus" ./ 2>/dev/null
fi


# Check if the executables exist and are executable, then show status with checkmarks or crosses
if [ -x "./philo" ]; then
    printf "${GREEN}✔ philo found${RESET}\n"
else
    printf "${RED}✖ philo not found${RESET}\n"
fi

if [ -x "./philo_bonus" ]; then
    printf "${GREEN}✔ philo_bonus found${RESET}\n"
else
    printf "${RED}✖ philo_bonus not found${RESET}\n"
fi

# Function definitions for tests (you already have these defined or sourced)
draw_progress_bar() {
  local __value=$1
  local __max=$2
  local __unit=${3:-""}
  if (( __max < 1 )); then __max=1; fi
  local __percentage
  __percentage=$(awk -v value="$__value" -v max="$__max" 'BEGIN { printf "%.2f", (value / max) * 100 }')
  local __num_bar
  __num_bar=$(awk -v perc="$__percentage" -v width="$PROGRESS_BAR_WIDTH" 'BEGIN { printf "%.0f", (perc * width) / 100 }')
  printf "["
  for (( b=1; b<=__num_bar; b++ )); do printf "#"; done
  for (( s=1; s<=(( PROGRESS_BAR_WIDTH - __num_bar )); s++ )); do printf " "; done
  printf "] %3.0f%% (%d / %d %s)\r" "$__percentage" "$__value" "$__max" "$__unit"
}

choose_test() {
  read -rn1 -p $'\nChoose test to run:\t
  [1] check invalid input (auto)\t
  [2] die tests - auto (can take a while)\t
  [3] no-die limited meals test (auto)\t
  [4] no-die tests (can take a while)\t
  [5] no-die tests (auto)\t
  [6] check data races && deadlocks (needs docker) \t
  [7] check timestamps - The Chefs Special \t
  [8] The Chaos Feast (auto)\t
  [ESC] exit tester\n\n' choice
  printf "\n"
  case $choice in
    1) check_invalid_inputs "$EXE" ;;
    2) die_test_auto "$EXE" ;;
    3) check_limited_meals "$EXE" ;;
    4) no_die_test "$EXE" ;;
    5) no_die_test_auto "$EXE" ;;
    6) run_helgrind "$EXE" ;;
    7) check_timestamps "$EXE" && process_files ;;
    8) check_invalid_inputs "$EXE" && check_limited_meals "$EXE" && \
         die_test_auto "$EXE" && no_die_test_auto "$EXE" && check_timestamps "$EXE" && process_files ;;
    $'\e') exit 0 ;;
    *) printf "${RED}Invalid choice\n${RESET}"; choose_test ;;
  esac
}

choose_bonus_test() {
  read -rn1 -p $'\nChoose bonus test to run:\t
  [1] check invalid input (auto)\t
  [2] die tests - auto (can take a while)\t
  [3] no-die limited meals test (auto)\t
  [4] no-die tests (can take a while)\t
  [5] no-die tests (auto)\t
  [6] check data races && deadlocks (needs docker) \t
  [7] check timestamps - The Chefs Special \t
  [8] The Chaos Feast (auto)\t
  [ESC] exit tester\n\n' choice
  printf "\n"
  case $choice in
    1) check_invalid_inputs "$EXE" ;;
    2) die_test_auto "$EXE" ;;
    3) check_limited_meals "$EXE" ;;
    4) no_die_test "$EXE" ;;
    5) no_die_test_auto "$EXE" ;;
    6) run_helgrind "$EXE" ;;
    7) check_timestamps "$EXE" && process_files ;;
    8) check_invalid_inputs "$EXE" && check_limited_meals "$EXE" && \
         die_test_auto "$EXE" && no_die_test_auto "$EXE" && check_timestamps "$EXE" && process_files ;;
    $'\e') exit 0 ;;
    *) printf "${RED}Invalid choice\n${RESET}"; choose_bonus_test ;;
  esac
}

# Let the user choose which executable to test (with ESC to exit)
printf "\nSelect the executable to test:\n"
read -rn1 -p $'\n[1] philo\n[2] philo_bonus\n[ESC] exit tester\n\n' exe_choice
printf "\n"
case $exe_choice in
  1) EXE="./philo" ;;
  2) EXE="./philo_bonus" ;;
  $'\e') exit 0 ;;
  *) printf "Invalid option. Exiting.\n"; exit 1 ;;
esac

# Define the progress bar width (if used in your tests)
PROGRESS_BAR_WIDTH=50

# Display header and description

printf "${BOLD}\n💭 The 42Philosophers Helper 💭\n${RESET}"
printf " ____  _     _ _                       _                   \n";
printf "|  _ \| |__ (_) | ___  ___  ___  _ __ | |__   ___ _ __ ___ \n";
printf "| |_) | '_ \| | |/ _ \/ __|/ _ \| '_ \| '_ \ / _ \ '__/ __|\n";
printf "|  __/| | | | | | (_) \__ \ (_) | |_) | | | |  __/ |  \__ \\ \n";
printf "|_|   |_| |_|_|_|\___/|___/\___/| .__/|_| |_|\___|_|  |___/\n";
printf "                                |_|    by Abdallah Zerfaoui\n\n";
printf "\nThis tester allows you to test:\n\n"
printf "\ta. Invalid input handling\n"
printf "\t- checks if the program handles invalid input correctly.\n\n"
printf "\tb. when philosophers should die\n"
printf "\t- checks if the program stops when a philosopher dies in the expected time.\n\n"
printf "\tc. when no philosophers should die\n"
printf "\t- checks if the program runs for a certain time without any philosopher dying.\n"
printf "\t with and without number of meals limitation.\n\n"
printf "\td. check for data races and deadlocks\n"
printf "\t- using helgrind, drd, and sanitizer.\n\n"
printf "\te. check timestamps\n"
printf "\t- checks if the program runs for a certain time without mixing timestamps\n\n"
printf "\tf. The Chaos Feast\n"
printf "\t- runs all tests in sequence.\n\n"
# printf "\t1. when your program should stop on death or when all philos have eaten enough\n"
# printf "\t- to be checked manually by the user, based on the expected result listed in yes-die.txt.\n\n"
# printf "\t2. when no philosophers should die\n"
# printf "\t- this is checked automatically if the program runs for x seconds (default 10) without death.\n"

# Run the appropriate test suite based on the chosen executable.
if [[ "$EXE" == *"philo_bonus"* ]]; then
    choose_bonus_test
else
    choose_test
fi
