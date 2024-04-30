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
export ZFILES=$PWD
LOG_FILE="errors.log"
DEBUG_STD="&>/dev/null"
DEBUG_ERROR="2>/dev/null"
source /etc/os-release

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
source $ZFILES/setup/essential.sh

# install GoLang
source $ZFILES/setup/golang.sh

# Adjust settings
source $ZFILES/setup/settings.sh

# Install tools
source $ZFILES/setup/tools.sh



