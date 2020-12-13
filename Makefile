DOTFILES := $(shell find dotfiles/ -type f -name "[^_]*")
DOTFILES := $(filter-out %.old, ${DOTFILES})
TARGETS := ${DOTFILES:dotfiles/%=target/%}
DEPENDENCIES := $(shell find dotfiles/ -type f)

.PHONY: render
render: ${TARGETS}

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
