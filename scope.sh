#!/bin/bash
# Author: Drian @xfdrian
# scope.sh v0.04

# Source the banner script
source "$(dirname "$0")/banner.sh"

clear
banner

# Check if required arguments are provided
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 --hackerone|--intigriti|--bugcrowd <program> [scope_file]"
    exit 1
fi

# Validate platform argument
case "$1" in
    --hackerone)
        PLATFORM="hackerone"
        ;;
    --intigriti)
        PLATFORM="intigriti"
        ;;
    --bugcrowd)
        PLATFORM="bugcrowd"
        ;;
    *)
        echo "[ERROR] Invalid platform: '$1'"
        echo "Valid options: --hackerone, --intigriti, --bugcrowd"
        exit 1
        ;;
esac

PROGRAM=$2
HUNT_DIR="$HOME/bug/$PLATFORM/$PROGRAM"
SCOPE_FILE="$HUNT_DIR/scope.txt"

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
