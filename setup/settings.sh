#!/bin/bash 
# settings.sh

echo "${YELLOW}[+] Running $0...${RESET}"
sleep 1

# Create local bin directory
mkdir -p ~/.local/go

# Move Go to local bin
if [ -d $HOME/go ]; then
    echo "${BLUE}[+] Moving Go folder...${RESET}"    
    mv $HOME/go $GOPATH
    time 2
else
    echo "${RED}[!] $HOME/go Directory does not exist!${RESET}"
fi

echo "${GREEN}[+] Done...${RESET}"
sleep 1
