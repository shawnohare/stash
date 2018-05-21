# Stash 

A simplified version of the symlink farm manager 
[GNU stow](https://www.gnu.org/software/stow/) written in POSIX shell script.
`stash` is feature minimal since its intended use case is symlinking user
configuration files stored in a version controlled repository. To this end,
directories are created rather than linked, so that data application
data does not migrate to a configuration repository.

# Example

TODO

# Installation

## Global(superuser access)

Since `stash` is just a simple executable shell script, it can be installed
globally via

```bash
sudo cp "bin/stash" /usr/local/bin/stash
sudo cp "man/stash.1" "/usr/local/man/man1/stash.1"
```

## Local

Ensure that `$XDG_BIN_HOME` (defaults to `~/.local/bin`) is in your `PATH`,
then navigate to the project root and issue:

```bash
make install
```

This exploits the fact that `man` searches `$path/share/man` for any
`$path` appearing in `PATH`.

## Git submodule

As the project originally grew out of a homegrown attempt to remove `stow`
as a dependency from user configuration logic, a natural use case is to 
make `stash` a submodue of a configuration repo and then call it as needed.

# Running tests

Install the shell scripting testing framework
[bats](https://github.com/bats-core/bats-core) and then from the project root: 

```bash
$ bats tests/*
```

# Similar Projects

1. The full-featured [GNU stow](https://www.gnu.org/software/stow/) is a 
   pearl script that is more suitable for package management. 

2. [stowsh](https://github.com/williamsmj/stowsh`) is a bash script with
   similar aims to `stash`, but the latter strives for utter simplicity and
   POSIX compliance.

