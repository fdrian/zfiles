#!/bin/bash
# essential.sh

echo "${YELLOW}[+] Running $0...${RESET}"

PACKAGE_LIST="$ZFILES/setup/packages/essential.txt" 

# Check system version
if [[ $ID == "arch" || $ID_LIKE == *"arch"* ]]; then
    sudo pacman -Syu
    if command -v yay &>/dev/null; then 
        while read -r package; do    
            if command -v $package &>/dev/null;then
                echo "${YELLOW}[+] $package is already installed!${RESET}"
            else
                yay -S --noconfirm --needed  $package 2>> $LOG_FILE
            fi
            
        done < "$PACKAGE_LIST"
    else
        echo "${RED}yay is not installed. Please install yay first.${RESET}"
    fi
elif [[ $ID == "ubuntu" || $ID_LIKE == *"debian"* ]]; then
    apt update
    while read -r package; do
        if command -v $package &>/dev/null;then
            echo "${YELLOW}[+] $package is already installed!${RESET}"
        else
            apt install -y $package 2>> $LOG_FILE
        fi

    done < "$PACKAGE_LIST"    
else
    echo "${RED}Distribution not supported for automatic package installation!${RESET}"
fi

sleep 1