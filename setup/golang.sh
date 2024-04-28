#!/bin/bash
# Install Latest GoLang

echo "${YELLOW}[+] Running $0...${RESET}"

sleep 1

install_go(){
    echo "${RED}Go is not installed. Proceeding with installation...${RESET}"
    local GO_VERSION=$(curl -L -s "https://golang.org/VERSION?m=text" | head -n 1)
    wget -q  --show-progress "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz" 

    echo "${BLUE}Extracting files${RESET}"
    sudo tar -C /usr/local -xzf ${GO_VERSION}.linux-amd64.tar.gz | pv
    rm -rf $GO_VERSION*

    if ! echo $PATH | grep -q "/usr/local/go/bin" ; then 
        echo "Added automatically - zfiles by Drian"
        echo "export PATH=\$PATH:/usr/local/go/bin" >> $HOME/.zshrc
    fi
    source $HOME/.zshrc 

}

# Check for existing Go Installation
if command -v go &>/dev/null; then
    CURRENT_GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//') # Strip "go" for comparison
    echo "${BLUE}Go is already installed (version: $CURRENT_GO_VERSION)${RESET}"

   LATEST_GO_VERSION=$(curl -L -s "https://golang.org/VERSION?m=text" | head -n 1 | sed 's/go//') # Strip "go" for comparison) 

    # Version Comparison
    if [[ $CURRENT_GO_VERSION < $LATEST_GO_VERSION ]]; then 
        echo "${YELLOW}A newer version of Go ($LATEST_GO_VERSION) is available. Would you like to update? (y/n) "  
        read -r update_choice
        if [[ $update_choice == "y" || $update_choice == "Y" ]]; then
            install_go
        else
            echo "Skipping update."
        fi
    elif [[ $CURRENT_GO_VERSION == $LATEST_GO_VERSION  ]]; then
        echo "${GREEN}You have the latest version of Go.${RESET}"
    else   
        echo "${RED}Check manually!${RESET}"
    fi 
else
    install_go
fi

sleep 1

# 