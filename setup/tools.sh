#!/bin/bash
#  Hacking Tools

echo "${YELLOW}[+] Running $0...${RESET}"

install_tool() {
  local TOOL="$1"
  local REPO="$2"

  # Check if tool is installed
  if command -v $tool &>/dev/null; then
    echo "${YELLOW}[+] $TOOL is already installed${RESET}"
  else
    echo "${BLUE}[+] Installing $TOOL${RESET}"
    sleep 1
    go install $REPO@latest | pv
  fi
}

TOOLS_LIST="$ZFILES/setup/packages/hacktools.txt" 

while read -r TOOL REPO; do    
    install_tool $TOOL $REPO
done < "$TOOLS_LIST"

# Config Dirs
mkdir -p ~/.gf
cp -r $GOPATH/src/github.com/tomnomnom/gf/examples ~/.gf

mkdir -p ~/Tools/
mkdir -p ~/Lists/
mkdir -p ~/.config/notify/
mkdir -p ~/.config/amass/
mkdir -p ~/.config/nuclei/

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

DIR="$HOME/Tools"
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

  if git clone "https://github.com/$REPO_PATH$REPO_NAME"; then
    sleep 100
    cd $REPO_NAME || continue # Skip to next repo if cd fails

    git pull $DEBUG_STD

    for REQ in requirements.txt setup.py Makefile; do
      if [ -s "$REQ" ]; then
        case "$REQ" in
          "requirements.txt") $SUDO pip3 install -r "$REQ" $DEBUG_LOG ;;
          "setup.py") $SUDO python3 "$REQ" install $DEBUG_LOG ;;
          "Makefile") $SUDO make $DEBUG_LOG; $SUDO make install $DEBUG_LOG ;;
        esac
      fi
    done

    # Repo-specific actions (GF patterns)
    if [[ "$REPO_NAME" == *gf* ]]; then
      mkdir -p ~/.gf && cp -r examples/*.json ~/.gf $DEBUG_LOG
    fi

    cd $DIR || continue

  else
    echo "${RED}[!] Unable to install $REPO_PATH, try manually!${RESET}\n"
  fi
done



echo "${GREEN} Finished...${RESET}"
sleep 1