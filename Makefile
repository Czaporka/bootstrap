SHELL := /usr/bin/bash

DOTFILES := $(shell find dotfiles/ -type f -name "[^_]*")
DOTFILES := $(filter-out %.old, ${DOTFILES})
TARGET := ${DOTFILES:dotfiles/%=target/%}

SCRIPTS := $(shell find scripts/ -type f -name "[^_]*")


.PHONY: render
render: ${TARGET}

.SUFFIXES:

#======================================================
#| Display status of every script and dotfile, one of:
#|   * Up to date
#|   * Differs
#|   * Not installed
#------------------------------------------------------
.PHONY: status
status: render
	@echo "==============================="
	@echo "|          dotfiles:"
	@echo "-------------------------------"
	@find target/ -type f | while read rendered; do \
		_scripts/print-status.sh $${rendered/target\//~/.} $${rendered}; \
	done
	@echo "==============================="
	@echo "|         scripts:"
	@echo "-------------------------------"
	@find scripts/ -type f | while read script; do \
		_scripts/print-status.sh $${script/scripts/~/.local/bin} $${script}; \
	done

#======================================================
#| Render a dotfile and put it into `target/`
#------------------------------------------------------
target/%: dotfiles/% render-single.py
	@_scripts/render-single.py dotfiles/$* ${@:%.j2=%}

#======================================================
#| Generate target for each script in `scripts/`, e.g.:
#|   * install-script-make-env
#|   * install-scrpt-...
#------------------------------------------------------
#| install-*
#------------------------------------------------------
.PHONY: install-script-%
install-script-targets := $(addprefix install-script-, ${SCRIPTS:scripts/%=%})
${install-script-targets}: install-script-%: scripts/%
	@mkdir -p ~/.local/bin
	# @cp $^ ~/.local/bin/$$(basename $* .sh)
	@_scripts/safe-install.sh $^ ~/.local/bin/$$(basename $* .sh)
	@chmod +x ~/.local/bin/$$(basename $* .sh)
#------------------------------------------------------
#| diff-*
#------------------------------------------------------
.PHONY: diff-script-%
diff-script-targets := $(addprefix diff-script-, ${SCRIPTS:scripts/%=%})
${diff-script-targets}: diff-script-%: scripts/%
# @diff -q $^ ~/.local/bin/$$(basename $* .sh) || diff --color -y <(sort $^) <(sort ~/.local/bin/$$(basename $* .sh))
	@diff -q $^ ~/.local/bin/$$(basename $* .sh) || diff --color -y $^ ~/.local/bin/$$(basename $* .sh)

#======================================================
#| Generate target for each file in `dotfiles/`, e.g.:
#|   * install-dotfile-bashrc
#|   * install-dotfile-vimrc
#|   * install-dotfile-...
#------------------------------------------------------
#| install-*
#------------------------------------------------------
.PHONY: install-dotfile-%
install-dotfile-targets := $(addprefix install-dotfile-, ${DOTFILES:dotfiles/%=%})
${install-dotfile-targets}: install-dotfile-%: target/%
	@echo "TODO: $*"
#------------------------------------------------------
#| diff-*
#------------------------------------------------------
.PHONY: diff-dotfile-%
diff-dotfile-targets := $(addprefix diff-dotfile-, ${DOTFILES:dotfiles/%=%})
${diff-dotfile-targets}: diff-dotfile-%: target/%
# @diff -q $^ ~/.$* || diff --color -y <(sort $^) <(sort ~/.$*)
	@diff -q $^ ~/.$* || diff --color -y $^ ~/.$*

.PHONY: clean
clean:
	@rm -rf target
