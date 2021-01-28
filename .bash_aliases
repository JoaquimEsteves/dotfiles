#!/usr/bin/env bash

# Enable alias expansion (useful for vim)
# See: https://stackoverflow.com/a/19819036
shopt -s expand_aliases
# Quickly reload bash from .bashrc
alias reloadbash=". ~/.bashrc"
# Make my sudo experience more wholesome
alias please="echo -e '\a' && sudo " 
# Ensures we can use aliases with sudo
alias sudo='sudo '
# Update and upgrade
alias update-upgrade="please apt update && please apt upgrade"
# Easy acces to the "file explorer" 
# (it actually tries to use the sensible choice for any file you try to open)
alias explorer="xdg-open " 


#################### RUST REPLACEMENTS FOR CLI TOOLS ############################
#                                                                               #
# The following are a series of fancy rust replacements for standard cli tools  #
# They're aliased so I always use the real one, although there's always         #
# a r<command> option to summon the _real_ version                              # 
#                                                                               # 
################################################################################# 

# BATCAT
# Neat little alternative to cat.
alias bat="/usr/bin/batcat "
alias cat="bat "
# Useful for piping long ass commands
alias catm="bat -l man "
alias rcat="'cat' "
# FD
# use fd as a modern replacement for find!
alias fd="/usr/bin/fdfind "
alias find="fd "
alias rfind="'find' "

# EXA
# exa is a pretty cool ls alternative
alias ls='$HOME/.cargo/bin/exa --icons '
alias lst="ls -T --level=1 "
alias rls="'ls' "
alias ll='exa -alF --icons --header --git --extended'
alias la='exa -a --icons'
alias l='exa -F --icons'

# RIPGREP + BAT
# ripgrep is yet another rust re-implementation
# this time of grep funnily enough
# batgrep is just ripgrep but with bat as output
alias grep='$HOME/.cargo/bin/rg ' 
alias rgrep="'grep' "
# batman is just the man pages but with bat output
alias man='$HOME/.local/bin/batman '
alias rman="'man' "
# DUST
# dust is du + rust
alias du='$HOME/.cargo/bin/dust '
alias rdu="'du' "
# SD
# SD is like sed, only rational
alias sed="sd "
alias rsed="command sd "
# YTOP
# ytop => like top only pretty
alias top="ytop "
alias rtop="command top "
# PS
# procs is a ps replacement
alias ps="procs --sortd cpu "
alias rps="command ps "



# quickly get all dotfiles
alias dotfiles="fd '^\.' . --maxdepth 1 --hidden --no-ignore "
# Quick copy to clipboard
# Use it with a pipe command for example
alias c2b="xclip -sel clip "
# Googler using w3m (ie: opening results in a terminal)
alias qgoogler="googler --url-handler w3m "
# TMUX STUFF
# Quickly attach to a tmux session by tag
alias tat="tmux attach -t "
# Quickly create a new tmux session
alias tnt="tmux new -s "
# See tmux sessions
alias tls="tmux ls "

if [ -f "$HOME/Scripts/html-mk-cat.sh" ]; then
	alias cgoogler='googler --url-handler=$HOME/Scripts/html-mk-cat.sh'
fi

### GIT AlIASES
alias gsts="git status --short "

# Get the weather!
alias weather="curl wttr.in "

# Neat file preview with fuzzy search and bat! Wow
alias preview="fzf --preview '/usr/bin/batcat --color \"always\" {}'"


################################################################################
#                                                                              #
#                                 pretty boxes                                 #
#                                                                              #
################################################################################
# Usage: pbox -d shell (This selects the shell style)
#        pbox -l (browse the styles!)
#        pbox -d <STYLE> -l (See the style's own "man" page)
# You can also just invoke a diferent size to change it
# Example: pbox -s 40x8
alias pbox="boxes -s 80x5 -a c "
