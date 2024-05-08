#!/bin/bash
#  Wordlists

echo "${YELLOW}[+] Running $0...${RESET}"

# Settings Wordlists
if [[ ! -d /usr/share/wordlists ]]; then
    mkdir -p /usr/share/wordlists

    wget -q -c --show-progress https://github.com/danielmiessler/SecLists/archive/master.zip -O /tmp/SecList.zip
    7z x /tmp/SecList.zip -o/usr/share/wordlists
    mv /usr/share/wordlists/SecLists-master /usr/share/wordlists/SecLists

    if ! grep -q "export WORDLIST=" ~/.zshrc ; then  
        echo "export WORDLIST=/usr/share/wordlists" >> $HOME/.zshrc      
    fi

    echo "${GREEN}[+] SecLists installed...${RESET}"
else
    echo "0"
fi