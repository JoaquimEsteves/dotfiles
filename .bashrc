#!/usr/bin/env bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

if [[ "${BASH_VERSINFO[0]}" -lt 5 ]]; then
  cat <<EOF
###############################################################################
#                                  Warning!                                   #
#                                Fucking MacOS                                #
###############################################################################
You're using a nearly twenty year old version of bash.
EOF
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# Ignore these silly commands from history
HISTIGNORE='ls:ll:ls -alh:pwd:clear:history'

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
HISTFILESIZE=100000

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

function __setup_ps1() {
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

PS1=$(__setup_ps1)

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
  # shellcheck disable=SC2015
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
#   (This is linux only)
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

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

if [ -f ~/.bash_functions ]; then
  # shellcheck source=/dev/null
  source ~/.bash_functions
fi
# HOMEBREW BULLSHIT

if [ -d ~/.local/bin ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
# PROBLEM LINE IS THIS SHIT
# _EVERYTIME_ we do an eval, it's dog slow!
# If spawning a new shell every becomes stupid slow run the command yourself and see what the output is
# PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/Users/jesteves/.local/share/mise/installs/node/24.14.1/bin:/opt/homebrew/opt/make/libexec/gnubin:/opt/homebrew/opt/coreutils/libexec/gnubin:/Users/jesteves/.local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# eval "$(/usr/bin/env /usr/libexec/path_helper -s)"
PATH="/opt/homebrew/bin:/opt/podman/bin:/Users/jesteves/.local/share/mise/installs/node/24.14.1/bin:/opt/homebrew/opt/openjdk/bin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:/opt/homebrew/opt/make/libexec/gnubin:/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/sbin:/Users/jesteves/.local/bin:/Users/jesteves/go/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/pkg/env/global/bin";
# NEW_PATH="$PATH"
[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

if [ -d "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" ]; then
  PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
fi

if [ -d "$HOMEBREW_PREFIX/opt/make/libexec/gnubin" ]; then
  PATH="$HOMEBREW_PREFIX/opt/make/libexec/gnubin:$PATH"
fi
if [ -d "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin" ]; then
  PATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
fi
###############################################################################
#                                  MAC CRAP!                                  #
###############################################################################
if [[ "$OSTYPE" == 'darwin*' ]]; then
  # Bash completion for make
  # For some reason, on `mac` it wasn't working
  complete -W "\$(grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile | sed 's/[^a-zA-Z0-9_.-]*$//')" make
  # macos only shenanigans
  if [[ -z "$LC_ALL" ]]; then
    export LC_ALL='en_US.UTF-8'
  fi
fi


if [[ -s $HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh ]]; then
  # shellcheck source=/dev/null
  LC_COLLATE=C LANG='' LC_CTYPE=C source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
fi

if [[ -d $HOMEBREW_PREFIX/opt/openjdk/bin ]]; then
  PATH="$HOMEBREW_PREFIX/opt/openjdk/bin:$PATH"
  # In case I need to do some fancy compilation
  # (Highly doubtful!)
  # export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
fi

for completion in "$HOMEBREW_PREFIX/etc/bash_completion.d/"*; do
  # shellcheck source=/dev/null
  source "$completion"
done
unset completion

# end-of Homebrew bullshit

# See: https://theleo.zone/posts/pager/
if command -v lore >/dev/null; then
  export PAGER=lore
fi

export DO_NOT_TRACK=1
# shellcheck source=/dev/null
[ -f ~/.config/bash_shit/mise.bash ] && source ~/.config/bash_shit/mise.bash

# yarn's global bin folder
[ -d ~/.yarn/bin ] && export PATH="$PATH:$HOME/yarn/bin"
# Go's standard bin
[ -d /usr/local/go/bin ] && export PATH=$PATH:/usr/local/go/bin
# Locally installed Go bins
# Generally with go install `whatever`
[ -d ~/go/bin ] && export PATH=$PATH:~/go/bin

# export local .hosts to /etc/host
export HOSTALIASES="$HOME/.hosts"
# Allow BAT (fancy cat built with RUST) to use 'less' with wheelscrool
export BAT_PAGER="less --tabs=4 -RF"

# FU microsoft telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# use vi
export EDITOR=nvim

########################################
#                                      #
#           FUZZY SEARCH FUN           #
#                                      #
########################################
# Allows shells to remember the history of other shells. (Useful for fzf + tmux)
# __REMOVED__: It was actually a pain in the ass
# export PROMPT_COMMAND="history -a; history -n"

# shellcheck source=/dev/null
[ -f ~/.config/bash_shit/fzf.bash ] && source ~/.config/bash_shit/fzf.bash

# Perl crap
if [ -d ~/perl5/bin ]; then
  export PATH=$PATH:~/perl5/bin

  PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
  export PERL5LIB

  PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
  export PERL_LOCAL_LIB_ROOT

  # shellcheck disable=SC2089
  PERL_MB_OPT="--install_base \"$HOME/perl5\""
  # shellcheck disable=SC2090
  export PERL_MB_OPT

  PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"
  export PERL_MM_OPT
fi

# LUA PATH SHENANIGANS
if command -v luarocks >/dev/null; then
  eval "$(luarocks path)"
fi

## COMPLETION
## Should be automatic - but isn't lol
if [ -d "$HOME"/.local/share/bash-completion/completions ]; then
  for f in "$HOME"/.local/share/bash-completion/completions/*; do
    # shellcheck disable=SC1090
    [ -f "$f" ] && . "$f"
  done
  unset f
fi

# UNCOMMENT THIS WHEN YOU WANT TO WORK WITH ANDROID AGAIN
# ANDROID_HOME=$HOME/Android/Sdk
#
# if [ -d $ANDROID_HOME ]; then
# 	export ANDROID_HOME
# 	export PATH=$PATH:$ANDROID_HOME/emulator
# 	export PATH=$PATH:$ANDROID_HOME/platform-tools
# fi

# update-alternatives was not setting the correct JAVA_HOME
JAVA_HOME=/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home/
if [ -d $JAVA_HOME ]; then
  export JAVA_HOME
fi

if command -v ng >/dev/null; then
  # Load Angular CLI autocompletion.
  # shellcheck disable=SC1090
  source <(ng completion script)
fi

if command -v eslint_d >/dev/null; then
  # Fix broken config shenanigans for eslint_d
  # Basically if you have the new
  # eslint.config.js then eslint_d just craps the bed
  # Annoying...
  export ESLINT_USE_FLAT_CONFIG=true
fi
# Force time to be yyyy-mm-ddThh:mm:ss+-timezone
export LC_TIME=en_DK.UTF-8
# Show a little TLDR if we're lucky
if command -v tldr >/dev/null && [[ $((RANDOM % 10)) -gt 5 ]]; then
  tldr --offline "$(tldr --offline --list | shuf -n1)"
fi

# Allows us to use zoxide, the fancy cd built with rust
# shellcheck disable=SC1090
[ -f ~/.config/bash_shit/zoxide.bash ] && source ~/.config/bash_shit/zoxide.bash
# Allow the use of direnv
# https://direnv.net/
# direnv hook bash > ~/.config/bash_shit/direnv.bash
# shellcheck disable=SC1090
[ -f ~/.config/bash_shit/direnv.bash ] && source ~/.config/bash_shit/direnv.bash
# shellcheck disable=SC1090
[ -f ~/.config/bash_shit/podman.bash ] && source ~/.config/bash_shit/podman.bash
# shellcheck disable=SC1090
[ -f ~/.config/bash_shit/hf.bash ] && source ~/.config/bash_shit/hf.bash

# Look at alieases only at the end, 'cos we want to do it after PATH
# editing shenanigans
if [ -f ~/.bash_aliases ]; then
  # shellcheck source=/dev/null
  . ~/.bash_aliases
fi
