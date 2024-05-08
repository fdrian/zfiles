#!/bin/bash
#  Hacking Tools

echo "${YELLOW}[+] Running $0...${RESET}"
TOOLS_LIST="$ZFILES/setup/packages/hacktools.txt" 
DIR="$HOME/Tools"

install_tool() {
  local TOOL="$1"
  local REPO="$2"

  # Check if tool is installed
  if command -v $TOOL &>/dev/null; then
    echo "${YELLOW}[+] $TOOL is already installed${RESET}"
  else
    echo "${BLUE}[+] Installing $TOOL${RESET}"
    sleep 1
    go install $REPO@latest | pv
  fi
}

while read -r TOOL REPO; do    
    install_tool $TOOL $REPO
done < "$TOOLS_LIST"

# Config Dirs
mkdir -p ~/.gf

# List of repositories
declare -A REPOS=( 
    ["gf"]="tomnomnom/gf"
    ["Gf-Patterns"]="1ndianl33t/Gf-Patterns"
    ["LinkFinder"]="dark-warlord14/LinkFinder"
    ["Interlace"]="codingo/Interlace"
    ["JSScanner"]="0x240x23elu/JSScanner"
    ["GitTools"]="internetwache/GitTools"
    ["SecretFinder"]="m4ll0k/SecretFinder"
    ["M4ll0k"]="m4ll0k/BBTz"
    ["Git-Dumper"]="arthaud/git-dumper"
    ["CORStest"]="RUB-NDS/CORStest"
    ["Knock"]="guelfoweb/knock"
    ["Photon"]="s0md3v/Photon"
    ["Sudomy"]="screetsec/Sudomy"
    ["DNSvalidator"]="vortexau/dnsvalidator"
    ["Massdns"]="blechschmidt/massdns"
    ["Dirsearch"]="maurosoria/dirsearch"
    ["Knoxnl"]="xnl-h4ck3r/knoxnl"
    ["xnLinkFinder"]="xnl-h4ck3r/xnLinkFinder"
    ["MSwellDOTS"]="mswell/dotfiles"
    ["Waymore"]="xnl-h4ck3r/waymore"
    ["altdns"]="infosec-au/altdns"
    ["XSStrike-Reborn"]="ItsIgnacioPortal/XSStrike-Reborn"
)


echo "${BLUE}\n Running: Installing repositories (${#REPOS[@]})${RESET}\n\n"

mkdir -p "$DIR" || {
   echo "Failed to create directory $DIR in ${FUNCNAME[0]} @ line ${LINENO}"
   exit 1
}
cd "$DIR" || {
   echo "Failed to cd to $DIR in ${FUNCNAME[0]} @ line ${LINENO}"
   exit 1
}

for REPO_PATH in "${REPOS[@]}"; do
  REPO_NAME=$(basename "$REPO_PATH")
  echo "${BLUE}[+] Installing $REPO_NAME | github.com/$REPO_PATH ${RESET}"
  
  if [ -d $REPO_NAME ]; then
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
      echo "${YELLOW} Checking updates for $REPO_NAME...${RESET}"
      cd $REPO_NAME || continue
      git pull --force $DEBUG_STD
    else      
      echo "${YELLOW}[*] Converting $REPO_NAME into a Git repo...${RESET}\n"
      rm -rf .git # Remove any leftover .git remnants (if necessary)
      git init 
      git remote add origin "https://github.com/$REPO_PATH"
      git pull origin master $DEBUG_STD 
    fi
  else
    if git clone "https://github.com/$REPO_PATH"; then
      
      for REQ in requirements.txt setup.py Makefile; do
        if [ -s "$REQ" ]; then
          case "$REQ" in
            "requirements.txt") $SUDO pip3 install -r "$REQ" $DEBUG_STD ;;
            "setup.py") $SUDO python3 "$REQ" install $DEBUG_STD ;;
            "Makefile") $SUDO make $DEBUG_STD; $SUDO make install $DEBUG_STD ;;
          esac
        fi
      done

      # Repo-specific actions (GF patterns)
      if [[ "$REPO_NAME" == *gf* ]]; then
        mkdir -p ~/.gf && cp -r examples/*.json ~/.gf
      fi

      cd $DIR || continue

    else
      echo "${RED}[!] Unable to install $REPO_PATH, try manually!${RESET}"
    fi
  fi
done

mkdir -p ~/Lists/
mkdir -p ~/.config/notify/
mkdir -p ~/.config/amass/
mkdir -p ~/.config/nuclei/


echo "${GREEN} Finished...${RESET}"
sleep 1