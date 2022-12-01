#!/usr/bin/env bash
# Install script for base ZSH configurations

if [[ "$EUID" = 0 ]]; then
    echo "(1) sudo permissions granted"
else
    sudo -k # make sure to ask for password on the next sudo
    if sudo true; then
        echo "(1) Permissions granted"
    else
        echo "Please run this script with sudo. Exiting"
        exit 1
    fi
fi

# Variables definiton
USER=$(whoami)
DIR=$(pwd)/src
DEST=${HOME}
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"


## Announce
message() {
	echo -e "${ORANGE}""[*] Installing base ZSH configurations...""${WHITE}"
}

# Dependencies
depends_check() { 
    dependencies=(git zsh)

    for dependency in "${dependencies[@]}"; do
        type -p "$dependency" &>/dev/null || {
            echo -e ${RED}"[!] ERROR: ${GREEN}'${dependency}'${RED}, could not be satisfied. Exiting." >&2
            { reset_color; exit 1; }
        }
    done
}

# Initialize submodules for the ZSH plugins
init_submods() {
    echo -e "${CYAN}""[*] Initializing plugins submodules...""${MAGENTA}"
    git submodule init
}

# Change the default login shell
change_sh() {
    echo -e "${CYAN}""[*] Changing shell for the current user...""${MAGENTA}"
    sudo usermod --shell /bin/zsh "$USER"
}

## Copy the configs
copy_files() {
	sudo cp -r "$DIR"/.zsh "$DEST"/.zsh && sudo cp -r "$DIR"/.zshrc "$DEST"/.zshrc

	echo -e ${GREEN}"[*] Configuration installed successfully. A reboot might be needed for changes to come in effect."${WHITE}
}

## Run functions
message
depends_check
init_submods
change_sh
copy_files
