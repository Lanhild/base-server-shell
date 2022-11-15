#!/bin/zsh
typeset -A _config
_config="$HOME/.zsh"
SHELL=$(which zsh || echo '/bin/zsh')

### Prompt path
fpath=(
    $HOME/.zsh/prompt/
    $fpath
    )

### Variables definitions
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r?$reset_color (Yes, No, Abort, Edit) "
export CLICOLOR=1
export KEYTIMEOUT=1
export GPG_TTY=$(tty)

### Define command aliases here
alias grep='grep --color=always'
alias lsa='ls -lah --color'
alias l='ls --color'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

### Shell prompt
_newline=$'\n'
_lineup=$'\e[1A'
_linedown=$'\e[1B'
PROMPT="%F{red}%n%F{white}@%F{green}%m %F{blue}%~ ${_newline}%F{white}$ "
RPROMPT='%{${_lineup}%}%F{red}%(?..%? )%F{yellow}%v%F{white}$(promptjobs) [`date +%H:%M:%S`]%{${_linedown}%}'

### Options set
setopt correct
setopt autocd              # change directory just by typing its name
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt MENU_COMPLETE        # Automatically highlight first element of completion menu
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.
setopt interactivecomments
setopt promptsubst
## Load and undefine options
autoload -U colors && colors
autoload -Uz compinit
compinit -i
unsetopt BEEP # Remove the PC board sound
unsetopt nomatch

### Shell history configurations
HISTFILE=$HOME/.zsh_history    # enable history saving on shell exit
setopt SHARE_HISTORY           # share history between sessions
HISTSIZE=10000                 # lines of history to maintain memory
SAVEHIST=1000                  # lines of history to maintain in history file.
setopt HIST_EXPIRE_DUPS_FIRST  # allow dups, but expire old ones when I hit HISTSIZE
setopt EXTENDED_HISTORY        # save timestamp and runtime information

zstyle ':completion:*' completer _complete # allows case insensitivity
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==34=34}:${(s.:.)LS_COLORS}")'; # Color completion folders
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31' # Kill colors
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:options' list-colors '=^(-- *)=34' # Options colors
zstyle ':completion:*' menu select

# Keybinds
bindkey '^P'             up-history # Scroll up in the history entries
bindkey '^N'             down-history # Scroll down in the history entries
bindkey '^?'             backward-delete-char # backspace and ^h working even after returning from command mode
bindkey '^h'             backward-delete-char # ctrl-h removes character backwards
bindkey -M viins '^u'    backward-kill-line # ctrl-u removes line backwards
bindkey '^w'             backward-kill-word # ctrl-w removes word backwards
bindkey '^r'             history-incremental-search-backward # ctrl-r searches history backwards
bindkey -M viins '^a'    beginning-of-line # Go the beginning of the line
bindkey -M viins '^e'    end-of-line # Go to the end of the line
bindkey -M viins '^k'    kill-line # Removes currrent line
bindkey -M viins '^xe'  edit-command-line
bindkey -M viins '^x^e'  edit-command-line
zle -N edit-command-line

### Custom functions
# Colorify man
function man() {
    env \
	LESS_TERMCAP_mb=$(printf "\e[1;31m") \
	LESS_TERMCAP_md=$(printf "\e[1;31m") \
	LESS_TERMCAP_me=$(printf "\e[0m") \
	LESS_TERMCAP_se=$(printf "\e[0m") \
	LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
	LESS_TERMCAP_ue=$(printf "\e[0m") \
	LESS_TERMCAP_us=$(printf "\e[1;32m") \
	man "$@"
}

function preexec {
    echo
}
function precmd {
    echo
}

function promptjobs {
    jobs %% 2> /dev/null | cut -d " " -f6
}

### Plugins options
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#484E5B,underline"
export AUTO_NOTIFY_THRESHOLD=20

### Plugins sourcing
source $_config/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $_config/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $_config/plugins/zsh-auto-notify/auto-notify.plugin.zsh


### EOF - All the bins or actions that need to be executed on shell opening 
### shall be put in this section
$_config/bin/fetchtool
