# Quickly reload bash from .bashrc
alias reloadbash=". ~/.bashrc"
# Make my sudo experience more wholesome
alias please="echo -e '\a' && sudo " 
# Ensures we can use aliases with sudo
alias sudo='sudo '
# Easily find django-admin
alias django-admin="python3 /home/lab-ubuntu/.local/lib/python3.8/site-packages/django/bin/django-admin.py"
# Easy acces to the "file explorer"
alias explorer="xdg-open " 
# RUST REPLACEMENTS FOR CLI TOOLS
# The following are a series of fancy rust replacements for standard cli tools
# They're aliased so I always use the real one, although there's always 
# a r<command> option to summon the _real_ version
# BATCAT
# Neat little alternative to cat.
alias bat="/usr/bin/batcat "
alias cat="bat "
alias rcat="'cat' "
# FD
# use fd as a modern replacement for find!
alias fd="/usr/bin/fdfind "
alias find="fd "
alias rfind="'find' "
# quickly get all dotfiles
alias dotfiles="fd '^\.' . --maxdepth 1 --hidden --no-ignore "
# EXA
# exa is a pretty cool ls alternative
alias ls="/home/lab-ubuntu/.cargo/bin/exa --icons "
alias lst="ls -T --level=1 "
alias rls="'ls' "
alias ll='exa -alF --icons --header --git --extended'
alias la='exa -a --icons'
alias l='exa -F --icons'
    
# RIPGREP + BAT
# ripgrep is yet another rust re-implementation
# this time of grep funnily enough
# batgrep is just ripgrep but with bat as output
alias grep="/home/lab-ubuntu/.cargo/bin/rg " 
alias rgrep="'grep' "
# batman is just the man pages but with bat output
alias man="/home/lab-ubuntu/.local/bin/batman "
alias rman="'man' "
# dust is du + rust
alias du="/home/lab-ubuntu/.cargo/bin/dust "
alias rdu="'du' "
# ytop => like top only pretty
alias top="ytop "
alias rtop="'top' "
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
