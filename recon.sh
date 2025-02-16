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

PLATFORM=$1
PROGRAM=$2
HUNT_DIR="$HOME/Hunt/$PLATFORM/$PROGRAM"
TOOLS_DIR="$HOME/Tools"
SCOPE_FILE="$HUNT_DIR/scope.txt"
ENV_FILE="$HOME/Hunt/.env"

# Load environment variables from .env file
if [[ -f "$ENV_FILE" ]]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
else
    echo "[ERROR] The .env file was not found! Set your API keys in $ENV_FILE."
    exit 1
fi


# Ensure the target directory exists
mkdir -p "$HUNT_DIR"

# Verify if the scope file exists
if [[ ! -f "$SCOPE_FILE" ]]; then
    echo "[ERROR] Scope file ($SCOPE_FILE) not found. Add target domains before running recon."
    exit 1
fi

echo "[+] Loading domains from scope..."
cp "$SCOPE_FILE" "$HUNT_DIR/domains.txt"

# Enumerate subdomains
echo "[+] Enumerating subdomains..."
subfinder -dL "$HUNT_DIR/domains.txt" -o "$HUNT_DIR/subfinder.txt"
assetfinder -subs-only $(cat "$HUNT_DIR/domains.txt") > "$HUNT_DIR/assetfinder.txt"
github-subdomains -dL "$HUNT_DIR/domains.txt" -t "$GITHUB_TOKEN" > "$HUNT_DIR/github.txt"
chaos -dL "$HUNT_DIR/domains.txt" -key "$CHAOS_API_KEY" -o "$HUNT_DIR/chaos.txt"
amass enum -passive -df "$HUNT_DIR/domains.txt" -o "$HUNT_DIR/amass.txt"

# Merge all subdomains into a single file
cat "$HUNT_DIR/"*.txt | sort -u > "$HUNT_DIR/subdomains.txt"

# Check for live subdomains
echo "[+] Checking for live subdomains..."
cat "$HUNT_DIR/subdomains.txt" | httpx -silent -o "$HUNT_DIR/alive.txt"

# Extract URLs and endpoints
echo "[+] Extracting URLs and endpoints..."
cat "$HUNT_DIR/alive.txt" | waybackurls > "$HUNT_DIR/wayback.txt"
cat "$HUNT_DIR/alive.txt" | gauplus > "$HUNT_DIR/gau.txt"
katana -list "$HUNT_DIR/alive.txt" -o "$HUNT_DIR/katana.txt"
hakrawler -url "$HUNT_DIR/alive.txt" -plain > "$HUNT_DIR/hakrawler.txt"
gospider -S "$HUNT_DIR/alive.txt" -o "$HUNT_DIR/gospider.txt"

cat "$HUNT_DIR/"*.txt | sort -u > "$HUNT_DIR/urls.txt"

# Search for parameters and endpoints
echo "[+] Searching for parameters and endpoints..."
cat "$HUNT_DIR/urls.txt" | unfurl --unique keys > "$HUNT_DIR/params.txt"
getJS --input "$HUNT_DIR/alive.txt" -o "$HUNT_DIR/js.txt"
subjs -i "$HUNT_DIR/alive.txt" -o "$HUNT_DIR/subjs.txt"
xnLinkFinder -i "$HUNT_DIR/urls.txt" -o "$HUNT_DIR/xnlinks.txt"

cat "$HUNT_DIR/params.txt" "$HUNT_DIR/js.txt" "$HUNT_DIR/subjs.txt" "$HUNT_DIR/xnlinks.txt" | sort -u > "$HUNT_DIR/endpoints.txt"

# Test for potential vulnerabilities
echo "[+] Testing for potential vulnerabilities..."
cat "$HUNT_DIR/endpoints.txt" | gf sqli > "$HUNT_DIR/sqli_candidates.txt"
cat "$HUNT_DIR/endpoints.txt" | gf xss > "$HUNT_DIR/xss_candidates.txt"
cat "$HUNT_DIR/endpoints.txt" | gf lfi > "$HUNT_DIR/lfi_candidates.txt"
cat "$HUNT_DIR/endpoints.txt" | gf ssrf > "$HUNT_DIR/ssrf_candidates.txt"

dalfox file "$HUNT_DIR/xss_candidates.txt" -o "$HUNT_DIR/xss_results.txt"
nuclei -l "$HUNT_DIR/alive.txt" -t ~/nuclei-templates/ -o "$HUNT_DIR/nuclei_results.txt"
subzy -targets "$HUNT_DIR/subdomains.txt" -o "$HUNT_DIR/takeover_results.txt"

echo "[+] Recon process completed. Results stored in $HUNT_DIR"
