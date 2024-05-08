#!/bin/bash
#  Hacking Tools

echo "${YELLOW}[+] Running $0...${RESET}"

install_tool() {
  local tool="$1"
  local repo="$2"

  # Check if tool is installed
  if command -v $tool &>/dev/null; then
    echo "${YELLOW}[+] $tool is already installed${RESET}"
  else
    echo "${BLUE}[+] Installing $tool${RESET}"
    sleep 1
    go install $repo@latest | pv
  fi
}

TOOLS_LIST="$ZFILES/setup/packages/tools.txt" 

while read -r tool repo; do    
    install_tool  $tool $repo
done < "$TOOLS_LIST"

echo "${GREEN} Finished...${RESET}"
sleep 1