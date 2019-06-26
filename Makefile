root:= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

tar := /usr/local
bin := "$(tar)/bin"
doc := "$(tar)/share/man/man1"
# XDG_BIN_HOME ?= ${HOME}/.local/bin
# XDG_DATA_HOME ?= ${HOME}/.local/share

.PHONY: install uninstall docs

all: install

test:
	rm -rf tmp
	bats tests/*
	rm -rf tmp

docs: 
	# mkdir -p "${XDG_DATA_HOME}/man/man1"
	sudo mkdir -p "$(doc)"
	sudo ln -f -s $(root)man/stash.1 "$(doc)/"

install: docs
	sudo ln -f -s $(root)bin/stash "$(bin)/"

uninstall:
	sudo rm -f "${bin}/stash"
	sudo rm -f "${doc}/stash.1"
