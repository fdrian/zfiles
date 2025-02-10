#!/bin/bash
# Drian

echo "${YELLOW}[+] Running $0...${RESET}"

Banner(){
   
    echo "██████╗░ ██████╗░ ██╗ ░█████╗░ ███╗░░██╗"
    echo "██╔══██╗ ██╔══██╗ ██║ ██╔══██╗ ████╗░██║"
    echo "██║░░██║ ██████╔╝ ██║ ███████║ ██╔██╗██║"
    echo "██║░░██║ ██╔══██╗ ██║ ██╔══██║ ██║╚████║"
    echo "██████╔╝ ██║░░██║ ██║ ██║░░██║ ██║░╚███║"
    echo "╚═════╝░ ╚═╝░░╚═╝ ╚═╝ ╚═╝░░╚═╝ ╚═╝░░╚══╝"
    echo "v0.01"
}

# Backup
cp ~/.zshrc ~/.zshrc.backup

# Constants
export ZFILES=$PWD
export DEBUG_STD="&>/dev/null"
export DEBUG_ERROR="2>/dev/null"
export LOG_FILE="$ZFILES/errors.log"
export DEBUG_LOG="2>>$LOG_FILE"
export SUDO="sudo"
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

# Install Hack Tools
source $ZFILES/setup/tools.sh

# Install wordlists
source $ZFILES/setup/wordlists.sh



