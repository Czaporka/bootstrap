TEMPLATES := $(shell find templates/ -type f -name "*.j2")
TARGETS := ${TEMPLATES:templates/%.j2=target/%}
DEPENDENCIES := $(dir ${TEMPLATES})/*

${TARGETS}: ${DEPENDENCIES} render.py
	@echo $^
	python3 render.py $(filter %.j2, $^) $@

.PHONY: clean
clean:
	@rm -rf target
