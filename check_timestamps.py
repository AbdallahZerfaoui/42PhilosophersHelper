import subprocess
import re
import sys

RED = '\033[31m'
GREEN = '\033[32m'
RESET = '\033[0m'

def strip_ansi_codes(line):
    """Removes ANSI escape codes from a string."""
    ansi_escape = re.compile(r'\x1b\[[0-9;]*m')
    return ansi_escape.sub('', line)

def check_timestamps_ascending(file_path):
    try:
        with open(file_path, "r") as f:
            lines = f.readlines()
        
        previous_timestamp = -1  # Start with an invalid timestamp
        line_idx = 0
        nbr_errors = 0
        for line in lines:
            cleaned_line = strip_ansi_codes(line)  # Remove ANSI codes
            match = re.match(r"(\d+)", cleaned_line)  # Match the first number after stripping ANSI codes
            if match:
                current_timestamp = int(match.group(1))
                if current_timestamp < previous_timestamp:
                    print(f"{RED}Error: Timestamp {current_timestamp} in line {line_idx} is not in ascending order {RESET}")
                    nbr_errors += 1
                previous_timestamp = current_timestamp
            line_idx += 1
        if (nbr_errors == 0):
            print(f"{GREEN}All timestamps are in ascending order.{RESET}")
        return True

    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
        return False
    except Exception as e:
        print(f"An error occurred: {e}")
        return False

def run_program_and_check(executable_path, program_args, output_file="output.txt"):
    try:
        # Combine the executable path and arguments
        command = [executable_path] + program_args
        
        # Run the C program and redirect its output to the specified file
        with open(output_file, "w") as outfile:
            subprocess.run(command, stdout=outfile, stderr=subprocess.PIPE, check=True)
        
        # Check timestamps in the output file
        return check_timestamps_ascending(output_file)
    except subprocess.CalledProcessError as e:
        print(f"Error: The program exited with an error.\n{e}")
        return False
    except Exception as e:
        print(f"An error occurred: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python check_timestamps.py <path_to_executable> [args...]")
        sys.exit(1)

    executable = sys.argv[1]
    args = sys.argv[2:]  # Remaining arguments passed to the program
    output_file = "output.txt"  # Default output file
    result = run_program_and_check(executable, args, output_file)
    sys.exit(0 if result else 1)