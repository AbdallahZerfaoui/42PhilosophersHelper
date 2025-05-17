#! /bin/bash

# Get the directory of the script itself
SCRIPT_DIR="$(dirname "$(readlink -f "$0" 2>/dev/null || echo "$0")")"

# Load all .sh files in test_modules (inside the script's directory)
for file in "$SCRIPT_DIR/test_modules/"*.sh; do
    [ -f "$file" ] && source "$file"
done
