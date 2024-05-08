#!/bin/bash
#  Wordlists

echo "${YELLOW}[+] Running $0...${RESET}"

if [[ ! -d /usr/share/wordlists ]]; then
    mkdir -p /usr/share/wordlits

    wget -q -c --show-progress https://github.com/danielmiessler/SecLists/archive/master.zip -O /tmp/SecList.zip
    7z x /tmp/SecList.zip -o/usr/share/wordlists
    echo "${GREEN}[+] SecLists installed...${RESET}"
else
    echo "0"
fi