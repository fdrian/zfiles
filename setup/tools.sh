#!/bin/bash
#  Hacking Tools

echo "${YELLOW}[+] Running $0...${RESET}"

install_tool() {
  local tool="$1"
  local repo="$2"
  echo "Installing $tool"
  sleep 1
  go install $repo@latest | pv
}

TOOLS_LIST="setup/packages/tools.txt" 


while read -r tool repo; do    
    install_tool  $tool $repo
done < "$TOOLS_LIST"

echo "${GREEN} Finished...${RESET}"
sleep 1