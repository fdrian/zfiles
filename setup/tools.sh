#!/bin/bash
# Hacking Tools Installer - Refactored

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

# Directories and files
TOOLS_LIST="$ZFILES/setup/packages/hacktools.txt"
DIR="$HOME/Tools"
LOG_FILE="$ZFILES/errors.log"
exec 2>> "$LOG_FILE"  # Redirect stderr to log file

# Ensure Tools directory exists
mkdir -p "$DIR" || {
    echo -e "${RED}[ERROR] Failed to create $DIR${RESET}"
    exit 1
}
cd "$DIR" || {
    echo -e "${RED}[ERROR] Failed to cd into $DIR${RESET}"
    exit 1
}

# Install Go-based tools
install_tool() {
    local TOOL="$1"
    local REPO="$2"

    if command -v "$TOOL" &>/dev/null; then
        echo -e "${YELLOW}[+] $TOOL is already installed${RESET}"
    else
        echo -e "${BLUE}[+] Installing $TOOL${RESET}"
        go install "$REPO@latest" 2>> "$LOG_FILE" || echo -e "${RED}[!] Failed to install $TOOL${RESET}"
    fi
}

while read -r TOOL REPO; do    
    install_tool "$TOOL" "$REPO"
done < "$TOOLS_LIST"

# Define repositories to clone
declare -A REPOS=( 
    ["gf"]="tomnomnom/gf"
    ["Gf-Patterns"]="1ndianl33t/Gf-Patterns"
    ["LinkFinder"]="dark-warlord14/LinkFinder"
    ["Interlace"]="codingo/Interlace"
    ["JSScanner"]="0x240x23elu/JSScanner"
    ["GitTools"]="internetwache/GitTools"
    ["SecretFinder"]="m4ll0k/SecretFinder"
    ["Git-Dumper"]="arthaud/git-dumper"
    ["CORStest"]="RUB-NDS/CORStest"
    ["Photon"]="s0md3v/Photon"
    ["Sudomy"]="screetsec/Sudomy"
    ["DNSvalidator"]="vortexau/dnsvalidator"
    ["Massdns"]="blechschmidt/massdns"
    ["Dirsearch"]="maurosoria/dirsearch"
    ["Waymore"]="xnl-h4ck3r/waymore"
    ["altdns"]="infosec-au/altdns"
    ["XSStrike-Reborn"]="ItsIgnacioPortal/XSStrike-Reborn"
)

# Clone or update repositories
for REPO_NAME in "${!REPOS[@]}"; do
    REPO_PATH="${REPOS[$REPO_NAME]}"
    echo -e "${BLUE}[+] Processing $REPO_NAME | github.com/$REPO_PATH${RESET}"
    
    if [[ -d "$REPO_NAME" ]]; then
        cd "$REPO_NAME" || continue
        if git rev-parse --is-inside-work-tree &>/dev/null; then
            echo -e "${YELLOW}[+] Updating $REPO_NAME${RESET}"
            git pull --force || echo -e "${RED}[!] Failed to update $REPO_NAME${RESET}"
        else
            echo -e "${YELLOW}[!] Converting $REPO_NAME to Git repository${RESET}"
            rm -rf .git
            git init
            git remote add origin "https://github.com/$REPO_PATH"
            git pull origin master || echo -e "${RED}[!] Failed to pull $REPO_NAME${RESET}"
        fi
        cd ..
    else
        git clone "https://github.com/$REPO_PATH" "$REPO_NAME" || echo -e "${RED}[!] Failed to clone $REPO_NAME${RESET}"
    fi

    # Handle dependencies
    for REQ in requirements.txt setup.py Makefile; do
        if [[ -s "$REPO_NAME/$REQ" ]]; then
            case "$REQ" in
                "requirements.txt") pip3 install -r "$REPO_NAME/$REQ" ;;
                "setup.py") python3 "$REPO_NAME/$REQ" install ;;
                "Makefile") make -C "$REPO_NAME" && make -C "$REPO_NAME" install ;;
            esac
        fi
    done
    
    # Special case for gf patterns
    if [[ "$REPO_NAME" == *gf* ]]; then
        mkdir -p ~/.gf && cp -r "$REPO_NAME/examples"/*.json ~/.gf/
    fi

done

# Ensure necessary directories exist
mkdir -p ~/Lists/
mkdir -p ~/.config/{notify,amass,nuclei}

echo -e "${GREEN}[+] Finished installing hacking tools${RESET}"
