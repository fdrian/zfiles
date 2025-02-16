#!/bin/bash
# Author: Drian - 
# Install Script v0.03

# Banner Function
banner() {
    echo -e "\e[34m"  # Set color to blue
    cat << "EOF"
██████╗░ ██████╗░ ██╗ ░█████╗░ ███╗░░██╗
██╔══██╗ ██╔══██╗ ██║ ██╔══██╗ ████╗░██║
██║░░██║ ██████╔╝ ██║ ███████║ ██╔██╗██║
██║░░██║ ██╔══██╗ ██║ ██╔══██║ ██║╚████║
██████╔╝ ██║░░██║ ██║ ██║░░██║ ██║░╚███║
╚═════╝░ ╚═╝░░╚═╝ ╚═╝ ╚═╝░░╚═╝ ╚═╝░░╚══╝
v0.03
EOF
    echo -e "\e[0m"  # Reset color
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo -e "\e[31m[ERROR] This script must be run as root (use sudo)\e[0m"
    exit 1
fi

# Set constants
export ZFILES=$PWD
export LOG_FILE="$ZFILES/errors.log"
exec 2>> "$LOG_FILE"  # Redirect stderr to log file with timestamps

log() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Set colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

clear
banner

# Detect OS
if [[ -f "/etc/os-release" ]]; then
    source /etc/os-release
else
    log "${RED}[ERROR] Unable to detect OS!${RESET}"
    exit 1
fi

# Backup .zshrc
ZSHRC_BACKUP="$HOME/.zshrc.backup.$(date '+%Y%m%d%H%M%S')"
cp ~/.zshrc "$ZSHRC_BACKUP" 2>/dev/null && log "${GREEN}[+] Backup of .zshrc created at $ZSHRC_BACKUP${RESET}" || log "${YELLOW}[WARNING] Failed to backup ~/.zshrc${RESET}"

# Install modules (parallel execution)
SETUP_SCRIPTS=(essential.sh golang.sh settings.sh wordlists.sh)

for script in "${SETUP_SCRIPTS[@]}"; do
    if [[ -f "$ZFILES/setup/$script" ]]; then
        log "${BLUE}[+] Running $script...${RESET}"
        bash "$ZFILES/setup/$script" &
    else
        log "${RED}[ERROR] $script not found! Skipping...${RESET}"
    fi
done
wait  # Aguarda todas as instalações paralelas terminarem

# Ensure Go is installed before running tools.sh
if ! command -v go &>/dev/null; then
    log "${RED}[ERROR] Go is not installed. Running golang.sh manually...${RESET}"
    bash "$ZFILES/setup/golang.sh"
fi

# Run tools.sh separately to avoid dependency issues
if [[ -f "$ZFILES/setup/tools.sh" ]]; then
    log "${BLUE}[+] Running tools.sh...${RESET}"
    bash "$ZFILES/setup/tools.sh"
else
    log "${RED}[ERROR] tools.sh not found! Skipping...${RESET}"
fi

log "${GREEN}[*] Installation completed!${RESET}"
