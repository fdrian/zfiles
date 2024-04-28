#!/bin/bash
# Essential packages

PACKAGE_LIST="setup/packages/essential.txt" 

echo "${BLUE} Running $0...${RESET}"

# Check system version
if [[ $ID == "arch" || $ID_LIKE == *"arch"* ]]; then
    if command -v yay &> /dev/null; then 
        while read -r package; do    
            yay -S --noconfirm --needed  $package || echo "${RED}$(date) -  Error installing $package${RESET}" >> $LOG_FILE
        done < "$PACKAGE_LIST"
    else
        echo "${RED}yay is not installed. Please install yay first.${RESET}"
    fi
elif [[ $ID == "debian" || $ID_LIKE == *"debian"* ]]; then
    while read -r package; do    
        apt install -y $package || echo "${RED}$(date) -  Error installing $package${RESET}" >> $LOG_FILE
    done < "$PACKAGE_LIST"    
else
    echo "Distribution not supported for automatic package installation."
fi

echo "${GREEN} Finished...${RESET}"
sleep 1