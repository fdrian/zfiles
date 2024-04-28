#!/bin/bash
# Essential packages

PACKAGE_LIST="setup/packages/essential.txt" 

echo "${YELLOW}[+] Running $0...${RESET}"

# Check system version
if [[ $ID == "arch" || $ID_LIKE == *"arch"* ]]; then
    if command -v yay &>/dev/null; then 
        while read -r package; do    
            yay -S --noconfirm --needed  $package || echo "${RED}$(date) -  Error installing $package${RESET}" >> $LOG_FILE
        done < "$PACKAGE_LIST"
    else
        echo "${RED}yay is not installed. Please install yay first.${RESET}"
    fi
elif [[ $ID == "ubuntu" || $ID_LIKE == *"debian"* ]]; then
    while read -r package; do    
        apt install -y $package || echo "${RED}$(date) -  Error installing $package${RESET}" >> $LOG_FILE
    done < "$PACKAGE_LIST"    
else
    echo "${RED}Distribution not supported for automatic package installation!${RESET}"
fi

sleep 1