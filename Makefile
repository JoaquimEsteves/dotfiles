# vim: list


define _help
###############################################################################
#                              DOT FILE INSTALL!                              #
###############################################################################

* all
  - normal:          Install all non dot-config files
  - config:          Install .config files form dot-config
  - bash_shit:       Install all of the `eval $(some_command)` into
                     `.config/bash_shit`
* get_homebrew: (Tries) to install homebrew. Checks a sha file just in case of
                funny business
* install_with_brew: Installs stuff from the `Brewfile`
* submodules         Inits the git-submodules
* submodules-update  Fetches the latest submodules
endef

help:
	$(info $(_help))
	@:
.PHONY: help

submodules:
	git submodule init
.PHONY: submodules
submodules-update:
	git submodule update --init --recursive
.PHONY: submodules

ifdef NO
CMD := stow --simulate
else
CMD := stow
endif

all: normal config bash_shit
.PHONY: all

normal:
	$(CMD) --verbose --dotfiles . --ignore=dot-config --target ~
.PHONY: normal

config:
	mkdir -p ~/.config
	$(CMD) --verbose --dotfiles dot-config --ignore=dot-config --target ~/.config
.PHONY: config

define installed
$(shell command -v $(1) 2>/dev/null)
endef

BS := ~/.config/bash_shit

bash_shit:
	mkdir -p $(BS)
ifneq ($(call installed,zoxide),)
	zoxide init bash > $(BS)/zoxide.bash
endif
ifneq ($(call installed,mise),)
	mise activate bash > $(BS)/mise.bash
endif
ifneq ($(call installed,fzf),)
	fzf --bash > $(BS)/fzf.bash
endif
ifneq ($(call installed,direnv),)
	direnv hook bash > $(BS)/direnv.bash
endif
ifneq ($(call installed,podman),)
	podman completion bash > $(BS)/podman.bash
endif
ifneq ($(call installed,hf),)
	# Has to be a bash, since hf will complain otherwise
	bash -c 'hf --show-completion bash > $(BS)/hf.bash'
endif
.PHONY: bash_shit

# Yeah yeah
# But look, it's a corporate macbook, what am I supposed to do?

get_homebrew:
ifeq ($(call installed,brew),)
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh > brew_install.sh
	sha256sum --check brew_install.sha256
	CI=true /bin/bash brew_install.sh
	rm brew_install.sh
else
	echo 'brew already installed you nerd'
endif
.PHONY: get_homebrew


ifneq ($(call installed,brew),)
install_with_brew:
	brew bundle install
endif
