root:= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
XDG_BIN_HOME ?= ${HOME}/.local/bin
XDG_DATA_HOME ?= ${HOME}/.local/share

.PHONY: install uninstall docs

all: install

test:
	rm -rf tmp
	bats tests/*
	rm -rf tmp

docs: 
	mkdir -p "${XDG_DATA_HOME}/man/man1"
	ln -f -s $(root)man/stash.1 "${XDG_DATA_HOME}/man/man1/"

install: docs
	ln -f -s $(root)bin/stash "${XDG_BIN_HOME}/"

uninstall:
	rm -f "${XDG_BIN_HOME}/stash"
	rm -f "${XDG_DATA_HOME}/man/man1/stash.1"
