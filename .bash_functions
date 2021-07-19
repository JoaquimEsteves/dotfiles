#!/usr/bin/env bash
# rename terminal window title
function set-title() {
	if [[ -z "$ORIG" ]]; then
		ORIG=$PS1
	fi
	TITLE="\[\e]2;$*\a\]"
	PS1=${ORIG}${TITLE}
}

# Appropriate for lxde or such other tools
# Uses X11 so should work on any non-wailand thing
function set-title-x() {
	local window_to_rename
	window_to_rename="$(wmctrl -l -p | awk '{s = ""; for (i=5; i<= NF; i++) s= s " " $i ; print $3 "\t" s}' | fzf --header "[PID]   [NAME] Select Window To Rename!" --header-lines=0)"
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
		fzf_with_controls 'batdiff --color {-1} | head -500' |
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
