SHELL := /usr/bin/bash

DOTFILES := $(shell find dotfiles/ -type f -name "[^_]*")
DOTFILES := $(filter-out %.old, ${DOTFILES})
TARGET_DOTFILES := ${DOTFILES:dotfiles/%=target/%}


.PHONY: render
render: ${TARGET_DOTFILES}

.SUFFIXES:

.PHONY: status
status: # render
	@bash ./status.sh

target/%: dotfiles/% render-single.py
	@python3 render-single.py dotfiles/$* ${@:%.j2=%}

.PHONY: install-scripts
install-scripts:
	@mkdir -p ~/.local/bin
	@chmod +x scripts/*
	@for item in scripts/*; do\
		cp -p $$item ~/.local/bin/$$(basename $$item .sh);\
	done

.PHONY: clean
clean:
	@rm -rf target
