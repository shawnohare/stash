root:= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

tar := /usr/local
bin := $(tar)/bin/stash
docs := $(tar)/share/man/man1
manpage := $(docs)/stash.1
# XDG_BIN_HOME ?= ${HOME}/.local/bin
# XDG_DATA_HOME ?= ${HOME}/.local/share

.PHONY: install uninstall docs

all: install

test:
	rm -rf tmp
	bats tests/*
	rm -rf tmp

$(manpage):
	sudo mkdir -p "$(docs)"
	sudo ln -f -s "$(root)man/stash.1" $@ 

$(bin):
	sudo ln -f -s "$(root)bin/stash" $@ 

install: $(manpage) $(bin) 

uninstall:
	sudo rm -f "$(bin)"
	sudo rm -f "$(manpage)"
