# shellcheck shell=bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
#
# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

function __normal_ps1() {
    local nc='\[\033[00m\]'
    local red='\[\033[01;31m\]' # red 31
    local uc='\[\033[01;36m\]'  # teal 36
    local tc='\[\033[01;32m\]'  # green 32
    local dc='\[\033[01;34m\]'  # dark blue
    local IFS=''
    local res

    if [ "$color_prompt" != yes ]; then
        # The disabling is on purpose, since PS1 will re-eval
        # every time
        # shellcheck disable=SC2016
        res=(
            '$(e=$?; if [[ $e != 0 ]] ; then echo "[\$?=$e] " ; fi)'
            '${debian_chroot:+($debian_chroot)}'
            '\u '
            '@ '
            '\t '
            'in '
            '$(pwd)'
            '\n\$ '
        )
    else
        # shellcheck disable=SC2016
        res=(
            # red background
            '$(e=$?; if [[ $e != 0 ]] ; then echo "'"$red"'\$?=$e'"$nc"' " ; fi)'
            '${debian_chroot:+($debian_chroot)}'
            "$uc"
            '\u '
            "$nc"
            '@ '
            "$tc"
            '\t '
            "$nc"
            'in '
            "$dc"
            '$(pwd)'
            "$nc"
            '\n\$ '
        )

    fi

    echo "${res[*]}"
}

PS1=$(__normal_ps1)

unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

#### CUSTOM STUFF YO
# use vi
export EDITOR=nvim

if [ -f ~/.bash_functions ]; then
    # shellcheck source=./.bash_functions
    . ~/.bash_functions
fi

# ALTERNATIVELY
# $ dir="${BASH_COMPLETION_DIR:-"${XDG_DATA_HOME:-"$HOME/.local/share"}/bash-completion"}/completions"
# $ mkdir -p "$dir"
# $ curl -fSsL "https://my_complete.bash" > "${dir?error: dir not set: you must run the previous commands first}/my_complete"
#
# I dislike the above because the name of the command must be exactly the same
# A bit shit
#
# shellcheck disable=SC1090
for completion in ~/.config/bash_completion/*.bash; do
    [ -e "$completion" ] || continue
    source "$completion"
done

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# ADD Go to path
if [ -d /usr/local/go/bin ]; then
    export PATH=$PATH:/usr/local/go/bin
fi


if [ -d ~/go/bin ]; then
    export PATH=$PATH:$(realpath ~/go/bin)
fi

# ADD ccache for FASTER builds!
if [ -d /usr/lib/ccache ]; then
    export CCACHE_SLOPPINESS="file_macro,time_macros"
    export PATH=/usr/lib/ccache:$PATH
fi

# pyenv - install multiple version of python
# PYENV_ROOT="$HOME/Programs/pyenv"
# if [ -d "$PYENV_ROOT" ]; then
#     export PYENV_ROOT
#     command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
#     eval "$(pyenv init -)"
#     # Optional plugin: https://github.com/pyenv/pyenv-virtualenv
#     # eval "$(pyenv virtualenv-init -)"
# fi

export PATH="$HOME/.local/share/uv/tools:$PATH"

# Node Version Manager
NVM_DIR="$HOME/.nvm"
if [ -d "$NVM_DIR" ]; then
    export NVM_DIR
    # shellcheck source=/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
    # shellcheck source=/dev/null
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
fi

export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

########################################
#                                      #
#           FUZZY SEARCH FUN           #
#                                      #
########################################
# Allows shells to remember the history of other shells. (Useful for fzf + tmux)
# __REMOVED__: It was actually a pain in the ass
# export PROMPT_COMMAND="history -a; history -n"
export FZF_DEFAULT_COMMAND='rg --files '

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"
# CTRL-T - Paste the selected file path into the command lne
# CTRL-R - Good ol history
# ALT-C - `cd` into some dir
# ALT-T Search and then execute some executable
# bind -m emacs-standard '"\et": "`fd -t x |fzf`\n"'
# shellcheck disable=SC2016
bind -m emacs-standard '"\et": "`fd -t x |fzf`\n"'

if [ -x "$(command -v zoxide)" ]; then
    eval "$(zoxide init bash)"
fi

if [ -x "$(command -v ng)" ]; then
    # Load Angular CLI autocompletion.
    # shellcheck source=/dev/null
    source <(ng completion script)
fi

if [ -x "$(command -v tldr)" ]; then
    tldr --quiet "$(tldr --quiet --list | shuf -n1)"
fi

if [ -x "$(command -v direnv)" ]; then
    eval "$(direnv hook bash)"
fi


if [ -f .nvmrc ]; then
    echo 'Found an nvmrc!'
    nvm use
fi

set_proxy skip_ln

export PAGER=nvimpager

if [ -f .venv/bin/activate ]; then
    echo 'Found a venv! Activated it. You can go back to normal with "deactivate"'
    # shellcheck source=/dev/null
    source .venv/bin/activate
fi
