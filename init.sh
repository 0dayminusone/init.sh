#!/usr/bin/env bash

## User defined variables
quit=modules/0-quit.sh
readme=modules/README-Manual.md

##script vars
distro=$(cat /etc/os-release | grep NAME=)
#deps
fzf=./deps/fzf
bat=./deps/bat
nvim=./deps/nvim-linux64/bin/nvim
rebos=./deps/rebos

# Changes pwd to current script working directory
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "$SCRIPT_DIR"

## Prompt for script root
sudo echo ""
echo "This script is now running with root privileges"
echo "====================================================================="

## Global Functions
# Response function - prompts user for confirmation
response() {
  echo "$1"
  read -p "Would you like to continue (y/n)? " latestresponse
  printf "\n"
}
# Done code function - provides visual separation and delay
donecode() {
  printf "\n"
  sleep "$1"
  printf "================================================================================"
  printf "================================================================================"
  printf "\n \n"
}
# Done module function - returns to main script after module completion
donemodule() {
  echo "Script module finished"
  echo "Returning to init.sh"
  sleep 0.75
  source $0
}

## Script start
lastmodule=$(ls -1 modules/ | "$fzf" --border=rounded)
lastmodule="modules/$lastmodule"

if [ "$lastmodule" == "$quit" ]; then
  printf "Exiting script\n"
  source "$lastmodule"
  exit
elif [[ "$lastmodule" == "$readme" ]]; then
  "$bat" --language markdown --paging=always --theme=gruvbox-dark "$readme"
  donemodule
else
  echo "=============================="
  echo "Module: $lastmodule"
  echo "=============================="
  printf "\n"
  source "$lastmodule"
fi
