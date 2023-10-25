root:= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

XDG_BIN_HOME ?= ${HOME}/.local/bin
XDG_DATA_HOME ?= ${HOME}/.local/share
bin := $(XDG_BIN_HOME)/stash
docs := $(XDG_DATA_HOME)/man/man1
manpage := $(docs)/stash.1


.PHONY: install uninstall docs

all: install

test:
	rm -rf tmp
	tests/bats/bin/bats tests/stash/*
	rm -rf tmp

$(manpage):
	mkdir -p "$(docs)"
	ln -f -s "$(root)man/stash.1" $@

$(bin):
	ln -f -s "$(root)bin/stash" $@

install: $(manpage) $(bin)

uninstall:
	rm -f "$(bin)"
	rm -f "$(manpage)"
