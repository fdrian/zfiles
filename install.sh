#!/bin/bash
# Drian - Install Script v0.02

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
v0.02
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
exec 2>> "$LOG_FILE"  # Redirect stderr to log file

# Set colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

clear
banner

# Backup
cp ~/.zshrc ~/.zshrc.backup 2>/dev/null || echo -e "${YELLOW}[WARNING] Failed to backup ~/.zshrc${RESET}"

# Install modules
SETUP_SCRIPTS=(essential.sh golang.sh settings.sh tools.sh wordlists.sh)

for script in "${SETUP_SCRIPTS[@]}"; do
    if [[ -f "$ZFILES/setup/$script" ]]; then
        echo -e "${BLUE}[+] Running $script...${RESET}"
        bash "$ZFILES/setup/$script"
    else
        echo -e "${RED}[ERROR] $script not found! Skipping...${RESET}"
    fi
    sleep 1
done

echo -e "${GREEN}[*] Installation completed!${RESET}"
