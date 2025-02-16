# ZSH
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="purify"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

alias recon="subfinder -d example.com | httpx -title"
alias scan="nuclei -l targets.txt"