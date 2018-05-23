XDG_BIN_HOME ?= ${HOME}/.local/bin
XDG_DATA_HOME ?= ${HOME}/.local/share

.PHONY: install uninstall docs

all: install


man/stash.1.gz:
	gzip --keep man/stash.1

docs: man/stash.1.gz

test:
	rm -rf tmp
	bats tests/*
	rm -rf tmp

install: docs
	cp bin/stash "${XDG_BIN_HOME}"
	cp man/stash.1.gz "${XDG_DATA_HOME}/man/man1/"

uninstall:
	rm -f "${XDG_BIN_HOME}/stash"
	rm -f "${XDG_DATA_HOME}/man/man1/stash.1.gz"
	
