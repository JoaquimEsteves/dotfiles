#!/usr/bin/env bash

function set_as_current_db() {
  # This is so that the sqls language server knows what db we should be connecting to
  if ! [[ -f "$1" ]]; then
    echo 'file not found'
    return 1
  fi

  if ! [[ -f "$HOME/.config/sqls/config.yml" ]]; then

    echo 'Creating sqls config'

    mkdir -p "$HOME"/.config/sqls
    mkdir -p "$HOME"/.local/share/current_db

    cat <<EOF >"$HOME"/.config/sqls/config.yml
lowercaseKeywords: false
connections:
  - alias: current
    driver: sqlite3
    dataSourceName: file:///$HOME/.local/share/current_db/db.db
EOF

  fi

  ln -sf "$(realpath "$1")" "$HOME"/.local/share/current_db/db.db
  echo "Current DB is now $1"
}

function mkcd() {
  ### Create a dir (including parents) and then cd to it.
  mkdir -p "$1" && cd "$1" || return 1
}

function mkdir_touch() {
  ### Touch AND make the dir recursively
  local file_path="$1"
  local dir_name
  dir_name=$(dirname "$file_path")

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

# Source for these two: https://github.com/dylanaraps/pure-bash-bible#conversion
rgb_to_hex() {
    # Usage: rgb_to_hex "r" "g" "b"
    printf '#%02x%02x%02x\n' "$1" "$2" "$3"
}

hex_to_rgb() {
    # Usage: hex_to_rgb "#FFFFFF"
    #        hex_to_rgb "000000"
    : "${1/\#}"
    ((r=16#${_:0:2},g=16#${_:2:2},b=16#${_:4:2}))
    printf '%s\n' "$r $g $b"
}

function check_special_characters() {
  echo -e '\e[1mBold\e[22m'
  echo -e '\e[2mDimmed\e[22m'
  echo -e '\e[3mItalic\e[23m'
  echo -e '\e[4mUnderlined\e[24m'
  echo -e '\e[4:3mCurly Underlined\e[4:0m'
  echo -e '\e[4:3m\e[58;2;240;143;104mColored Curly Underlined\e[59m\e[4:0m'
  echo -e '\e[5mBlinking\e[25m'
  echo -e '\e[6mNo idea\e[26m'
  echo -e '\e[7mHighlighted\e[27m'
  echo -e 'Hidden ->\e[8mHidden\e[28m <- no more hidden'
  echo -e '\e[9mStrike-through\e[29m'
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
  if [[ -x "$(command -v exa)" ]]; then
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
  window_to_rename="$(wmctrl -l -p |
    awk '{s = ""; for (i=5; i<= NF; i++) s= s " " $i ; print $3 "\t" s}' |
    fzf --header "[PID]   [NAME] Select Window To Rename!" --header-lines=0)"
  window_to_rename="$(echo "$window_to_rename" | awk '{ print $1 }')"
  if [ -n "$1" ]; then
    new_name="$1"
  else
    echo -n 'Input new name: '
    read -r new_name
  fi
  xdotool search --onlyvisible --pid "$window_to_rename" --name "\a\b\c" set_window --name "$new_name"
}

function tnt() {

  if [ -z "$1" ]; then
    tmux
  else
    tmux new -s "$1"
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
  git -c color.status=always status --short |
    fzf_with_controls 'bat --diff --color always {-1} | head -500' |
    cut -c4- | sed 's/.* -> //'
}

_gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
    fzf_with_controls 'git show --color=always {}'
}

_gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always "$@" |
    fzf_with_controls 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -500' |
    command grep -o "[a-f0-9]\{7,\}"
}

fkill() {
  local pid
  if [ "$UID" != "0" ]; then
    pid=$(command ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
  else
    pid=$(command ps -ef | sed 1d | fzf -m | awk '{print $2}')
  fi

  if [ "$pid" != "" ]; then
    echo "$pid" | xargs kill "-${1:-9}"
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
