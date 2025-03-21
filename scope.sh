#!/bin/bash
# Author: Drian @xfdrian
# scope.sh v0.09

# Source the banner script if it exists
BANNER_FILE="$(dirname "$0")/banner.sh"
if [[ -f "$BANNER_FILE" ]]; then
    source "$BANNER_FILE"
    clear
    banner
else
    echo "[WARNING] Banner file not found: $BANNER_FILE"
fi

# Check if required arguments are provided
if [[ $# -lt 2 ]]; then
    echo -e "[ERROR] Missing arguments!"
    echo -e "Usage: $0 --hackerone|--intigriti|--bugcrowd <program> [scope_file]"
    exit 1
fi

# Validate platform argument
case "$1" in
    --hackerone) PLATFORM="hackerone" ;;
    --intigriti) PLATFORM="intigriti" ;;
    --bugcrowd) PLATFORM="bugcrowd" ;;
    *)
        echo -e "[ERROR] Invalid platform: '$1'"
        echo -e "Valid options: --hackerone, --intigriti, --bugcrowd"
        exit 1
        ;;
esac

PROGRAM=$2

# Validate program name (only allow alphanumeric characters, underscores, and hyphens)
if [[ ! "$PROGRAM" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo -e "[ERROR] Invalid program name: '$PROGRAM'. Only alphanumeric characters, underscores, and hyphens are allowed."
    exit 1
fi

HUNT_DIR="$HOME/bug/$PLATFORM/$PROGRAM"
SCOPE_FILE="$HUNT_DIR/scope.txt"

# Create required directories
mkdir -p "$HUNT_DIR"
echo "[+] Directory created: $HUNT_DIR"

# If a scope file is provided, copy it to the correct location
if [[ -n "$3" ]]; then
    if [[ -f "$3" ]]; then
        cp "$3" "$SCOPE_FILE"
        echo "[+] Scope file copied to $SCOPE_FILE"
    else
        echo "[ERROR] Scope file not found: $3"
        exit 1
    fi
else
    # Create an empty scope file if none is provided
    touch "$SCOPE_FILE"
    echo "[+] Empty scope file created: $SCOPE_FILE"
    echo "[!] Please edit this file to add target domains."
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