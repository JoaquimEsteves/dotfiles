#!/usr/bin/env bash

function mkdir_cd() {
  ### Create a dir (including parents) and then cd to it.
  mkdir -p "$1" && cd "$1" || return 1
}

function mkdir_touch() {
  ### Touch AND make the dir recursively
  local file_path="$1"
  local dir_name
  dirname=$(dirname "$file_path")

  mkdir -p "$dir_name" && touch "$file_path"
}

function goat() {
command cat <<-EOF
(_(
/_/'_____/)
"  |      |
   |""""""|
EOF
}

# rename terminal window title
function set-title() {
  if [[ -z "$ORIG" ]]; then
    ORIG=$PS1
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1=${ORIG}${TITLE}
}

function readable_path() {
  tr ':' '\n' <<<"$PATH"
}

function every_binary() {
  if [[ -x $(which exa) ]]; then
    readable_path | xargs exa -alF --icons --header --extended
  else
    readable_path | xargs ls -la
  fi
}

function tempe() {
    cd "$(mktemp -d)" || return 1
    # Only I - the user, can read/write/execute
    # Doesn't seem to be necessary...
    # chmod -R a+rwx,g-rwx,o-rwx .
}

touch_with_dirs() {
    # Just like `touch` but creates the directories that lead up to it
    local file_path="$1"
    local dir
    dir=$(dirname "$file_path")

    # Create directories if they don't exist
    mkdir -p "$dir"

    # Create the file
    touch "$file_path"
}

# Appropriate for lxde or such other tools
# Uses X11 so should work on any non-wailand thing
function set-title-x() {
  local window_to_rename
  window_to_rename="$(wmctrl -l -p \
    | awk '{s = ""; for (i=5; i<= NF; i++) s= s " " $i ; print $3 "\t" s}' \
    | fzf --header "[PID]   [NAME] Select Window To Rename!" --header-lines=0)"
  window_to_rename="$(echo "$window_to_rename" | awk '{ print $1 }')"
  if [ -n "$1" ]; then
    new_name="$1"
  else
    echo -n 'Input new name: '
    read -r new_name
  fi
  xdotool search --onlyvisible --pid "$window_to_rename" --name "\a\b\c" set_window --name "$new_name"
}

function mkcd() {
  # Create a dir (including parents) and then cd to it.
  # We use cmake because mkdir -p is not recommended in many
  # manuals
  # See: https://unix.stackexchange.com/a/277154
  # Disabled spellcheck because we obviously _just_ created the dir
  # shellcheck disable=SC2164
  cmake -E make_directory "$1" && cd "$1"
}

function tnt() {

if ! [ -z "$1" ]
then
     tmux
else
  tmux new -s $1
fi


}

# Call `unicode` with the given arguments, and then pipe to awk, printing the first field.
# Throws error if no args passed
function unicode-fzf() {
  if [ -z "$1" ]; then
    echo "No arguments passed"
    return 1
  fi
  unicode --brief --max 0 "$@" | fzf | awk '{ print $1 }'
}

# These should really be their own git-something.sh functions
# But I'm lazy atm

is_in_git_repo() {
  git rev-parse HEAD >/dev/null 2>&1
}

fzf_with_controls() {
  fzf --ansi --no-sort --reverse --multi --bind 'alt-j:preview-down,alt-k:preview-up' \
    --header 'Ctrl-j: Down, Ctrl-k: Up Alt-j:preview-down,Alt-k:preview-up' --preview "$@"
}

_gf() {
  is_in_git_repo || return
  git -c color.status=always status --short \
    | fzf_with_controls 'batdiff --color {-1} | head -500' \
    | cut -c4- | sed 's/.* -> //'
}

_gt() {
  is_in_git_repo || return
  git tag --sort -version:refname \
    | fzf_with_controls 'git show --color=always {}'
}

_gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always "$@" \
    | fzf_with_controls 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -500' \
    | command grep -o "[a-f0-9]\{7,\}"
}

fkill() {
  local pid
  if [ "$UID" != "0" ]; then
    pid=$(command ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
  else
    pid=$(command ps -ef | sed 1d | fzf -m | awk '{print $2}')
  fi

  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

killport() {
  # source https://news.ycombinator.com/item?id=35698782
  lsof -ti :"$1" | xargs kill -9
}

########################################
#                                      #
#           FUZZY SEARCH FUN           #
#                                      #
########################################

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
