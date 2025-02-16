#!/bin/bash
# Author: Drian @xfdrian
# scope.sh v0.01

# Source the banner script
source "$(dirname "$0")/banner.sh"

clear
banner

# Check if required arguments are provided
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <platform> <program> [scope_file or scope.csv]"
    exit 1
fi

PLATFORM=$1
PROGRAM=$2
HUNT_DIR="$HOME/Hunt/$PLATFORM/$PROGRAM"
SCOPE_FILE="$HUNT_DIR/scope.txt"

# Ensure required directories exist
mkdir -p "$HUNT_DIR"

# If a scope file is provided, process it
if [[ -n "$3" && -f "$3" ]]; then
    FILE_TYPE=$(file --mime-type -b "$3")
    
    if [[ "$FILE_TYPE" == "text/plain" ]]; then
        # If it's a plain text file, copy it as scope.txt
        cp "$3" "$SCOPE_FILE"
        echo "[+] Scope file copied to $SCOPE_FILE"
    elif [[ "$FILE_TYPE" == "text/csv" ]]; then
        # If it's a CSV file, extract eligible domains
        echo "[+] Processing CSV file: Extracting eligible domains..."
        awk -F ',' 'NR>1 && $4=="true" {print $1}' "$3" | sort -u > "$SCOPE_FILE"
        echo "[+] Extracted domains saved to $SCOPE_FILE"
    else
        echo "[ERROR] Unsupported file format: $3"
        exit 1
    fi
else
    # If no scope file is provided, create an empty one
    touch "$SCOPE_FILE"
    echo "[+] Created new empty scope file: $SCOPE_FILE"
fi

# Display the directory structure
echo "[+] Directory structure:"
tree "$HOME/Hunt/$PLATFORM"

# Show extracted scope contents
if [[ -s "$SCOPE_FILE" ]]; then
    echo "[+] Domains in scope:"
    cat "$SCOPE_FILE"
else
    echo "[!] No domains listed. Edit $SCOPE_FILE to add targets."
fi