# vim: list
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

ZOXIDE_INSTALLED := $(call installed,zoxide)

bash_shit:
	mkdir -p ~/.config/bash_shit
ifneq ($(call installed,zoxide),)
	zoxide init bash > ~/.config/bash_shit/zoxide.bash
endif
ifneq ($(call installed,mise),)
	mise activate bash > ~/.config/bash_shit/mise.bash
endif
ifneq ($(call installed,fzf),)
	fzf --bash > ~/.config/bash_shit/fzf.bash
endif
ifneq ($(call installed,direnv),)
	direnv hook bash > ~/.config/bash_shit/direnv.bash
endif
ifneq ($(call installed,podman),)
	podman completion bash > ~/.config/bash_shit/podman.bash
endif
ifneq ($(call installed,hf),)
	# Has to be a bash, since hf will complain otherwise
	bash -c 'hf --show-completion bash > ~/.config/bash_shit/hf.bash'
endif

.PHONE: bash_shit

