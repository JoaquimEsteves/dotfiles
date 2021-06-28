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

# These should really be their own git-something.sh functions
# But I'm lazy atm

is_in_git_repo() {
	git rev-parse HEAD >/dev/null 2>&1
}

fzf-down() {
	fzf-tmux --height 50% "$@" --border
}

_gf() {
	is_in_git_repo || return
	git -c color.status=always status --short |
		fzf-down -m --ansi --nth 2..,.. \
			--preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
		cut -c4- | sed 's/.* -> //'
}

_gt() {
	is_in_git_repo || return
	git tag --sort -version:refname |
		fzf-down --multi --preview-window right:70% \
			--preview 'git show --color=always {} | head -'$LINES
}

_gh() {
	is_in_git_repo || return
	git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always "$@"|
		fzf-tmux --ansi --no-sort --reverse --multi --bind 'alt-j:preview-down,alt-k:preview-up' \
			--header 'Ctrl-j: Down, Ctrl-k: Up Alt-j:preview-down,Alt-k:preview-up' \
			--preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
		command grep -o "[a-f0-9]\{7,\}"
}
