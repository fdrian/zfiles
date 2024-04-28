#!/bin/bash
# Drian

echo "${YELLOW}[+] Running $0...${RESET}"

Banner(){
    echo ""
    echo "░       ░░░       ░░░        ░░░      ░░░   ░░░  ░"
    echo "▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒  ▒▒    ▒▒  ▒"
    echo "▓  ▓▓▓▓  ▓▓       ▓▓▓▓▓▓  ▓▓▓▓▓  ▓▓▓▓  ▓▓  ▓  ▓  ▓"
    echo "█  ████  ██  ███  ██████  █████        ██  ██    █"
    echo "█       ███  ████  ██        ██  ████  ██  ███   █"   
    echo "v0.01"
}

# Constants
LOG_FILE="install_errors.log"
DEBUG_STD="&>/dev/null"
DEBUG_ERROR="2>/dev/null"

# Colors
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`  
RESET=`tput sgr0`

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 
   exit 1
fi

clear
Banner

# Install Essential  
source setup/essential.sh

# install GoLang
source setup/golang.sh

# Install tools
source setup/tools.sh



