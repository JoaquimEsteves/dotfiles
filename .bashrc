#!/usr/bin/env bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

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
force_color_prompt=yes

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

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	;;
*) ;;

esac

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
# Removed because of conflicts with `exa`
# See bash_aliases
# alias ll='ls -alF'
# alias la='ls -A'
# alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	# shellcheck source=/dev/null
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		# shellcheck source=/dev/null
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		# shellcheck source=/dev/null
		. /etc/bash_completion
	fi
fi


################################################################################
#                                                                              #
#                                 CUSTOM SHIT                                  #
#                                                                              #
################################################################################

export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# shellcheck source=/dev/null
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# yarn's global bin package
export PATH="$PATH:~/.yarn/bin"

# export local .hosts to /etc/host
export HOSTALIASES="$HOME/.hosts"
# Allow BAT (fancy cat built with RUST) to use 'less' with wheelscrool
export BAT_PAGER="less --tabs=4 -RF"
# Allows us to use zoxide, the fancy cd built with rust
eval "$(zoxide init bash)"
# Add a carriage return to PS1
# (Don't ask me how this works...)
PS1=${PS1%?}
PS1=${PS1%?}\n'$ '
#### CUSTOM FUNCTIONS ####

if [ -f ~/.bash_functions ]; then
	# shellcheck source=/dev/null
	. ~/.bash_functions
fi

# FU microsoft telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# use vi
export EDITOR=vim
###### AZERTY KEYBOARD SHENANIGANS ######
#                                       #
# Stupid bloody azerty keyboards are    #
# bloody unusable.                      #
# So I'm replacing loads of of these    #
# silly things for reasonable inputs.   #
# Obviously don't use this if you're    #
# not on azerty.                        #
#                                       #
#########################################
# Defaults fzf expansion to $$
# fzf expands with:
#
#   Files under the current directory
#   - You can select multiple items with TAB key
#    vim **<TAB>
#
#    # Files under parent directory
#    vim ../**<TAB>
#
#    # Files under parent directory that match `fzf`
#    vim ../fzf**<TAB>
#
#    # Files under your home directory
#    vim ~/**<TAB>
#
#
#    # Directories under current directory (single-selection)
#    cd **<TAB>
#
#    # Directories under ~/github that match `fzf`
#    cd ~/github/fzf**<TAB>
export FZF_COMPLETION_TRIGGER='$$'

# Setup Caps locks => escape key
setxkbmap -option caps:escape

# French Keyboard Crap!
# maps è to /
# xmodmap -e "keycode 16 = KP_Divide"
# maps § to \
# xmodmap -e "keycode 15 = backslash"
# Set capslocks to be equal to escape
# setxkbmap -option caps:escape
########################################
#                                      #
#           FUZZY SEARCH FUN           #
#                                      #
########################################
# Allows shells to remember the history of other shells. (Useful for fzf + tmux)
# __REMOVED__: It was actually a pain in the ass
# export PROMPT_COMMAND="history -a; history -n"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Allow the use of direnv
# https://direnv.net/
eval "$(direnv hook bash)"
