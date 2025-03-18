#!/bin/bash
# Author: Drian @xfdrian
# golang.sh v0.02
# Install or update the latest GoLang version

YELLOW='\033[1;33m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
RED='\033[1;31m'
RESET='\033[0m'

echo -e "${YELLOW}[+] Running $0...${RESET}"
sleep 1

install_go() {
    local GO_VERSION=$(curl -sL "https://golang.org/VERSION?m=text" | head -n 1)
    local GO_TAR="${GO_VERSION}.linux-amd64.tar.gz"

    echo -e "${YELLOW}[+] Installing Go: $GO_VERSION ${RESET}"

    # Remove any existing Go installation
    sudo rm -rf /usr/local/go

    # Download and extract Go
    wget -q --show-progress "https://go.dev/dl/${GO_TAR}"
    echo -e "${BLUE}[+] Extracting files...${RESET}"
    sudo tar -C /usr/local -xzf "${GO_TAR}"
    rm -f "${GO_TAR}"

    # Ensure Go is added to PATH
    export PATH=$PATH:/usr/local/go/bin

    # Configure GOPATH and other environment variables
    mkdir -p ~/.local/go/bin

    echo -e "${BLUE}[+] Setting Go environment variables...${RESET}"

    # Check if GOPATH is already set in ~/.zshrc
    if ! grep -q "export GOPATH=" ~/.zshrc; then
        echo "# Added automatically - zfiles by @xfdrian" >> ~/.zshrc
        echo "export GOPATH=\$HOME/.local/go" >> ~/.zshrc
        echo "export GOBIN=\$HOME/.local/go/bin" >> ~/.zshrc
        echo "export PATH=\$GOBIN:\$PATH" >> ~/.zshrc
        echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.zshrc
    fi

    source ~/.zshrc

    echo -e "${GREEN}[+] Go installation completed! Run 'go version' to verify.${RESET}"
}

# Check for existing Go installation
if command -v go &>/dev/null; then
    CURRENT_GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
    LATEST_GO_VERSION=$(curl -sL "https://golang.org/VERSION?m=text" | head -n 1 | sed 's/go//')

    echo -e "${BLUE}Go is already installed (version: $CURRENT_GO_VERSION)${RESET}"

    # Compare versions (use sort for numeric comparison)
    if [[ "$(echo -e "$CURRENT_GO_VERSION\n$LATEST_GO_VERSION" | sort -V | tail -n 1)" != "$CURRENT_GO_VERSION" ]]; then
        echo -e "${YELLOW}A newer version of Go ($LATEST_GO_VERSION) is available. Would you like to update? (y/n)${RESET}"
        read -r update_choice
        if [[ $update_choice == "y" || $update_choice == "Y" ]]; then
            install_go
        else
            echo "Skipping update."
        fi
    else
        echo -e "${GREEN}You have the latest version of Go.${RESET}"
    fi
else
    echo -e "${RED}[!] Go is not installed. Proceeding with installation...${RESET}"
    install_go
fi

sleep 1
