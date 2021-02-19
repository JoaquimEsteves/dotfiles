#!/usr/bin/env bash
# rename terminal window title
function set-title() {
	if [[ -z "$ORIG" ]]; then
		ORIG=$PS1
	fi
	TITLE="\[\e]2;$*\a\]"
	PS1=${ORIG}${TITLE}
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
