#!/usr/bin/env bash

# Enable alias expansion (useful for vim)
# See: https://stackoverflow.com/a/19819036
shopt -s expand_aliases

# Safety...
alias rm="rm -i "
alias rrm="command rm "

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
alias cat="bat --paging=never "
alias pat="bat --paging=always "
# Useful for piping long ass commands
alias patm="pat -l man "
alias rcat="command cat "
# FD
# use fd as a modern replacement for find!
alias fd="/usr/bin/fdfind "
alias fd_all="fd --hidden --no-ignore "
alias find="fd "
alias rfind="command find "

# EXA
# exa is a pretty cool ls alternative
alias ls='$HOME/.cargo/bin/exa --icons '
alias lst="ls -T --level=1 "
alias lsd="ls -d */ "
alias rls="command ls "
alias ll='exa -alF --icons --header --git --extended'
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
alias man='$HOME/.local/bin/batman '
alias rman="command man "
# DUST
# dust is du + rust
alias du='$HOME/.cargo/bin/dust '
alias rdu="command du "
# SD
# SD is like sed, only rational
# Sadly operates poorly with FZF :(
# alias sed="sd "
# alias rsed="command sd "
# YTOP
# ytop => like top only pretty
alias top="ytop "
alias rtop="command top "
# PS
# procs is a ps replacement
alias ps="procs --sortd cpu "
# Adds a cute little hierarchical tree :)
alias pst="procs --tree "
alias rps="command ps "

# quickly get all dotfiles
alias dotfiles="fd '^\.' . --maxdepth 1 --hidden --no-ignore "
# Quick copy to clipboard
# Use it with a pipe command for example
alias c2b="xclip -sel clip "
# Googler, but default size of results to 5 so it actually fits on
# my tiny ass screen
alias googler="googler -n 5 "
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
alias music_vis="cava"

# I just keep forgetting the name of this damn program
# `$ tldr arecord`
alias music_record="arecord "
# I always forget the fekin' command for this
alias music_on_console="mocp"

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
alias connda="conda activate psdd-boost-1-app"
# TODO: Use `git` do CD over to the nearest .venv
alias venv='source .venv/bin/activate'



# See: https://www.youtube.com/watch?v=8bnd-SMYXi0
# Good video. I have some things worth mentioning: Instead of aliasing cat to
# bat, I recommend aliasing cat to `bat --paging=never`, and then aliasing pat
# (or similar) to `bat --paging=always`. Then, you have easy ways for normal
# terminal output, guaranteed paging without touching your precious scrollback,
# and smartly paging if the length is long enough, but all of them with syntax
# highlighting, line numbers, file/source names, and other really nice features
# that cat (or less) doesn't have, and of course, actual cat can be used by just
# doing \cat instead of cat. Some aliases, such as `alias cp='cp --verbose
# --reflink=auto --archive'`, I consider important enough to even put them in the
# global shell init file. Of course, I also have a whole host of commands aliased
# to just the verbose versions of themselves (i.e. `alias rm=rm\ --verbose mv=mv\
# --debug`, et cetera), in addition to commands aliased to themselves with
# automatic color (like grep --color=auto, though I actually don't find it
# necessary often, as most programs, that I use at least automatically use it
# when the output's a TTY. I actually have a global alias (one of those zsh
# features you miss out on in bash, unless bash added it recently) set up to
# easily have forced paged colorization, which probably sees far more use
# than all the --color=auto's and friends combined for me), And a bunch more
# aliases (currently a bit over 60 in total), but most of my stuff is in
# functions - whether alias-like ones like `which() {which "$@" | bat
# -language=bash }`, or pipeline monstrosities like `doas btrfs --verbose f
# du --raw - "$@" | tail -n +2 | rg -v '^\s*\d+\s+0\s+' | sd -p
# '^\s*(?P<pre>(\d+\s+){2})-(?P<post>\s+)' '${pre}0$post' | sd -p
# '^\s*(?P<total>\d+)\s+(?P<exclusive>\d+)\s+(?P<set_shared>\d+)\s+'
# '$total\t$exclusive\t$set_shared\t' | sort -sr -t $'\t' -k 4 | tail -n
# +$((# + 1)) | awk -F $'\t' '{if ($4"/" != substr(previous_line, 1,
# length($4) + 1)) {print} previous_line = $4}' | sort -nr -k 2 | numfmt
# --to=iec --field=1-3 -d $'\t'`, or 20 line backup functions that would
# probably have been a lot less painful to robustify if written in a "proper"
# programming language... Regarding eza, I've used exa (what eza is an
# inferior fork of) for years as my ls command, and the only flags that I
# find really necessary are `--binary --classify -a`. `--binary` ensures it
# won't use harmfully wrong units when you pass -l or similar to it, -a
# actually shows you files starting with a dot, and --classify is very nice
# to have, making exa show a / after directories, an @ after symlinks, and a
# * after executable files so you can find them at a glance even in a
# colorless environment. Grouping directories first is harmful, in my
# opinion, and the rich coloration combined with the --classify flag renders
# its benefits mostly moot anyways. I've tried icons and found them to
# basically just be bloat, but to each their own.
