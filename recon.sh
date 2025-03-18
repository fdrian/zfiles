#!/bin/bash
# Author: Drian @xfdrian
# recon.sh v0.01

# Source the banner script
source "$(dirname "$0")/banner.sh"

clear 
banner

# Check if the required arguments are provided
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <platform> <program>"
    exit 1
fi

# Load environment variables from .env file
ENV_FILE="$HOME/bug/.env"

if [[ -f "$ENV_FILE" ]]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
else
    echo "[ERROR] .env file not found! Ensure API keys are set in $ENV_FILE."
    exit 1
fi

PLATFORM=$1
PROGRAM=$2
HUNT_DIR="$HOME/bug/$PLATFORM/$PROGRAM"
TOOLS_DIR="$HOME/Tools"
SCOPE_FILE="$HUNT_DIR/scope.txt"

# Ensure required directories exist
mkdir -p "$HUNT_DIR"

# Check if scope file exists
if [[ ! -f "$SCOPE_FILE" ]]; then
    echo "[ERROR] Scope file ($SCOPE_FILE) not found. Add target domains before running recon."
    exit 1
fi

echo "[+] Loading domains from scope..."
cp "$SCOPE_FILE" "$HUNT_DIR/domains.txt"

# Fastest and most reliable source: `subfinder`
echo "[+] Running subfinder (fastest)..."
subfinder -dL "$HUNT_DIR/domains.txt" -o "$HUNT_DIR/subfinder.txt"

# Extra API-based sources (run only if API keys are available)
if [[ -n "$GITHUB_TOKEN" ]]; then
    echo "[+] Running github-subdomains (requires API key)..."
    github-subdomains -dL "$HUNT_DIR/domains.txt" -t "$GITHUB_TOKEN" > "$HUNT_DIR/github.txt"
fi

if [[ -n "$CHAOS_API_KEY" ]]; then
    echo "[+] Running chaos (requires API key)..."
    chaos -dL "$HUNT_DIR/domains.txt" -key "$CHAOS_API_KEY" -o "$HUNT_DIR/chaos.txt"
fi

# Merge all subdomains into a single file
cat "$HUNT_DIR/"*.txt | sort -u > "$HUNT_DIR/subdomains.txt"

# DNS Resolution with `dnsx`
echo "[+] Resolving valid subdomains using dnsx..."
dnsx -l "$HUNT_DIR/subdomains.txt" -o "$HUNT_DIR/resolved.txt"

# Web server validation with `httpx`
echo "[+] Checking for live web servers..."
httpx -l "$HUNT_DIR/resolved.txt" -silent -o "$HUNT_DIR/alive.txt"

# Optional: Deep scan using `amass` (only if needed)
if [[ "$3" == "--deep" ]]; then
    echo "[+] Running deep passive recon with amass..."
    amass enum -passive -df "$HUNT_DIR/domains.txt" -o "$HUNT_DIR/amass.txt"
    cat "$HUNT_DIR/amass.txt" >> "$HUNT_DIR/subdomains.txt"
    sort -u -o "$HUNT_DIR/subdomains.txt" "$HUNT_DIR/subdomains.txt"
fi

echo "[+] Recon process completed. Results stored in $HUNT_DIR"