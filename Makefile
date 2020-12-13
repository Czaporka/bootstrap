SHELL := /usr/bin/bash

DOTFILES := $(shell find dotfiles/ -type f -name "[^_]*")
DOTFILES := $(filter-out %.old, ${DOTFILES})
TARGET := ${DOTFILES:dotfiles/%=target/%}

SCRIPTS := $(shell find scripts/ -type f -name "[^_]*")


.PHONY: render
render: ${TARGET}

.SUFFIXES:

.PHONY: status
status: render
	@echo "==============================="
	@echo "|          dotfiles:"
	@echo "-------------------------------"
	@find target/ -type f | while read rendered; do \
		bash ./print-status.sh $${rendered/target\//~/.} $${rendered}; \
	done
	@echo "==============================="
	@echo "|         scripts:"
	@echo "-------------------------------"
	@find scripts/ -type f | while read script; do \
		bash ./print-status.sh $${script/scripts/~/.local/bin} $${script}; \
	done

target/%: dotfiles/% render-single.py
	@python3 render-single.py dotfiles/$* ${@:%.j2=%}

#======================================================
#| Generate target for each script in `scripts/`, e.g.:
#|   * install-script-make-env
#|   * install-scrpt-...
#------------------------------------------------------
.PHONY: install-script-%
install-script-targets := $(addprefix install-script-, ${SCRIPTS:scripts/%=%})
${install-script-targets}: install-script-%: scripts/%
	@mkdir -p ~/.local/bin
	@cp $^ ~/.local/bin/$$(basename $* .sh)
	@chmod +x ~/.local/bin/$$(basename $* .sh)

#======================================================
#| Generate target for each file in `dotfiles/`, e.g.:
#|   * install-dotfile-bashrc
#|   * install-dotfile-vimrc
#|   * install-dotfile-...
#------------------------------------------------------
.PHONY: install-dotfile-%
install-dotfile-targets := $(addprefix install-dotfile-, ${DOTFILES:dotfiles/%=%})
${install-dotfile-targets}: install-dotfile-%: target/%
	@echo success

.PHONY: clean
clean:
	@rm -rf target
