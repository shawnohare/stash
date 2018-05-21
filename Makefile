XDG_BIN_HOME ?= ${HOME}/.local/bin
XDG_DATA_HOME ?= ${HOME}/.local/share

.PHONY: install uninstall

install:
	cp bin/stash "${XDG_BIN_HOME}/stash"
	$(shell gzip --keep --force man/man1/stash.1)
	cp man/man1/stash.1.gz "${XDG_DATA_HOME}/man/man1/stash.1.gz"
	
