#!/usr/bin/env bash

# Enable alias expansion (useful for vim)
# See: https://stackoverflow.com/a/19819036
shopt -s expand_aliases

# Safety...
alias rm="rm -i "
alias rrm="command rm "
# alias cp='cp --verbose --reflink=auto --archive '
# alias rm='rm --verbose '
# alias mv='mv --debug '

# Quickly reload bash from .bashrc
alias reloadbash=". ~/.bashrc"
# Make my sudo experience more wholesome
# (also adds my $PATH so I can get access to .local/bin)
alias please="echo -e '\a' && sudo -E env \"PATH=$PATH\" "
# Ensures we can use aliases with sudo
alias sudo='sudo '
# Update and upgrade
alias update-upgrade="please apt update && please apt upgrade"
# Easy acces to the "file explorer"
# (it actually tries to use the sensible choice for any file you try to open)
alias explorer="xdg-open "
# nvim is good
# alias vim="nvim "
alias g="git "
# Philipp's funny little emoji picker with fzf
#alias emoj="emoji-fzf preview \
#	  | fzf --preview 'emoji-fzf get --name {1}' \
#	  | cut -d \" \" -f 1 \
#	  | emoji-fzf get"
alias emoj='emoji-fzf preview  | fzf -m --preview "emoji-fzf get --name {1}" | cut -d " " -f 1 | while read -r line; do echo $(echo $line | emoji-fzf get); done'
# to copy to xclip system keyboard (on mac use pbcopy) after selecting
alias emojc="emoj | xclip -selection c"

#################### RUST REPLACEMENTS FOR CLI TOOLS ############################
#                                                                               #
# The following are a series of fancy rust replacements for standard cli tools  #
# They're aliased so I don't use the real one, although there's always          #
# a r<command> option to summon the _real_ version                              #
#                                                                               #
#################################################################################

# BATCAT
# Neat little alternative to cat.
alias bat="/usr/bin/batcat "
# Thank youtube comment at: https://www.youtube.com/watch?v=8bnd-SMYXi0&lc=UgxT4f6_P4Px1iS-mX54AaABAg.9zwHY-l7QPVA-dqPA_8_Au
alias cat="bat --paging=never"
alias pat="bat --paging=always"
# Useful for piping long ass commands
alias catm="pat -l man "
alias rcat="command cat "
# FD
# use fd as a modern replacement for find!
# alias fd="/usr/bin/fdfind "
alias fd_all="fd --hidden --no-ignore "
alias find="fd "
alias rfind="command find "

# EXA
# exa is a pretty cool ls alternative
alias ls='exa --binary --classify --all --icons '
alias lst="ls -T --level=1 "
alias lsd="ls -d */ "
alias rls="command ls "
alias ll='exa -alF --icons --header --extended'
alias la='exa -a --icons'
alias l='exa -F --icons'

# RIPGREP + BAT
# ripgrep is yet another rust re-implementation
# this time of grep funnily enough
# batgrep is just ripgrep but with bat as output
# Removed: Too many programs where using standard grep.
# rg is easier to type than grep anyway lol
# alias grep='$HOME/.cargo/bin/rg '
alias rgrep="command grep "
# batman is just the man pages but with bat output
# alias man='$HOME/.local/bin/batman '
# alias rman="command man "
# DUST
# dust is du + rust
alias du='du'
alias rdu="command du "
# SD
# SD is like sed, only rational
# Sadly operates poorly with FZF :(
# alias sed="sd "
# alias rsed="command sd "
# YTOP
# ytop => like top only pretty
# alias top="ytop "
# alias rtop="command top "
# PS
# procs is a ps replacement
# alias ps="procs --sortd cpu "
# Adds a cute little hierarchical tree :)
# alias pst="procs --tree "
# alias rps="command ps "

# quickly get all dotfiles
alias dotfiles="fd '^\.' . --maxdepth 1 --hidden --no-ignore "
# Quick copy to clipboard
# Use it with a pipe command for example
alias c2b="xclip -sel clip "
# Googler, but default size of results to 5 so it actually fits on
# my tiny ass screen
# alias googler="googler -n 5 "
# Googler using w3m (ie: opening results in a terminal)
# alias qgoogler="googler --url-handler w3m "
# TMUX STUFF
# Quickly attach to a tmux session by tag
alias tat="tmux attach -t "
# Quickly create a new tmux session
alias tnt="tmux new -s "
# See tmux sessions
alias tls="tmux ls "

if [ -f "$HOME/Scripts/html-mk-cat.sh" ]; then
	# use googler but with a custom html -> markdown -> batcat converter!
	# __Very__ dank, but doesn't work half the time
	alias cgoogler='googler --url-handler=$HOME/Scripts/html-mk-cat.sh'
fi

################################################################################
#                                                                              #
#                                  Cool Shit                                   #
#                                                                              #
################################################################################

# See https://github.com/flash-global/shipperportal-front/pull/1135
# alias music_vis="cava"

# I just keep forgetting the name of this damn program
# `$ tldr arecord`
# alias music_record="arecord "

# Get the weather!
alias weather="curl wttr.in "

# Neat file preview with fuzzy search and bat! Wow
alias preview="fzf --preview '/usr/bin/batcat --color \"always\" {}'"

# Usage: pbox -d shell (This selects the shell style)
#        pbox -l (browse the styles!)
#        pbox -d <STYLE> -l (See the style's own "man" page)
# You can also just invoke a diferent size to change it
# Example: pbox -s 40x8
alias pbox="boxes -s 79x5 -a c "
alias unicornbox="boxes -a c -d unicornsay "
alias record_screen="ffmpeg -framerate 25 -f x11grab -i :1 -f pulse -ac 2 -i default output.mp4"

# Allows up-arrow to go to the previous command
alias lua="rlwrap lua"
