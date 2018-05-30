# Stash 

A simplified version of the package symlink manager 
[GNU stow](https://www.gnu.org/software/stow/) written in POSIX shell script.
`stash` is feature minimal since its intended use case is symlinking user
configuration files stored in a version controlled repository. To this end,
directories are created rather than linked, so that data application
data does not migrate to a configuration repository.

# Example

TODO

# Installation

## Local

Ensure that that `${XDG_DATA_HOME}/../bin` (defaults to
`${XDG_BIN_HOME:-~/.local/bin}`) is an element of `$PATH` then navigate to the
project root and issue:

```bash
make 
```

The man page is installed to `${XDG_DATA_HOME}/man/man1`, which `man` will
search provided that `${XDG_DATA_HOME}/../bin` is an element of `$PATH`.

## Global(superuser access)

Since `stash` is just a simple executable shell script, it can be installed
globally via

```bash
sudo ln -f -s "bin/stash" "/usr/local/bin/"
sudo ln -f -s "man/stash.1" "/usr/local/man/man1/"
```

# Tests 

Install the shell scripting testing framework
[bats](https://github.com/bats-core/bats-core) and then from the project root: 

```bash
$ make test
```

# Similar Projects

1. The full-featured [GNU stow](https://www.gnu.org/software/stow/) is a 
   pearl script that is more suitable for package management. 

2. [stowsh](https://github.com/williamsmj/stowsh`) is a bash script with
   similar aims to `stash`, but the latter strives for utter simplicity and
   POSIX compliance.

