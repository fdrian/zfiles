#!/bin/bash
# Author: Drian @xfdrian
# scope.sh v0.03

# Source the banner script
source "$(dirname "$0")/banner.sh"

clear
banner

# Check if required arguments are provided
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <platform> <program> [scope_file]"
    exit 1
fi

PLATFORM=$1
PROGRAM=$2
HUNT_DIR="$HOME/bug/$PLATFORM/$PROGRAM"
SCOPE_FILE="$HUNT_DIR/scope.txt"

# Validate platform (only allow hackerone, intigriti, bugcrowd)
VALID_PLATFORMS=("hackerone" "intigriti" "bugcrowd")
IS_VALID_PLATFORM=false

for VALID in "${VALID_PLATFORMS[@]}"; do
    if [[ "$PLATFORM" == "$VALID" ]]; then
        IS_VALID_PLATFORM=true
        break
    fi
done

if [[ "$IS_VALID_PLATFORM" == false ]]; then
    echo "[ERROR] Invalid platform: '$PLATFORM'"
    echo "Valid options: hackerone, intigriti, bugcrowd"
    exit 1
fi

# Create required directories
mkdir -p "$HUNT_DIR"

# If a scope file is provided, copy it to the correct location
if [[ -n "$3" && -f "$3" ]]; then
    cp "$3" "$SCOPE_FILE"
    echo "[+] Scope file copied to $SCOPE_FILE"
else
    # Create an empty scope file if none is provided
    touch "$SCOPE_FILE"
    echo "[+] Scope file created: $SCOPE_FILE"
fi

# Display the directory structure
echo "[+] Directory structure:"
if command -v tree &>/dev/null; then
    tree "$HOME/bug/$PLATFORM"
else
    ls -R "$HOME/bug/$PLATFORM"
fi

# Display the scope file contents if it exists
if [[ -s "$SCOPE_FILE" ]]; then
    echo "[+] Domains in scope:"
    cat "$SCOPE_FILE"
else
    echo "[!] No domains listed yet. Edit $SCOPE_FILE to add targets."
fi
