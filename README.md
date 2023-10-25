# stash - simple symlink manager.

A simplified symlink manager symlink manager 
similar to [GNU stow](https://www.gnu.org/software/stow/) written in POSIX shell script.
`stash` is feature minimal since its intended use case is symlinking user
configuration files stored in a version controlled repository. To this end,
directories are created rather than linked, so that data application
data does not migrate to a configuration repository.

## Example usage

```bash
stash ~/dotfiles/config ~/.config
```

## Install

`stash` is a single shell executable.

The included Makefile will perform a user-level install by 
linking the `stash` executable to `XDG_BIN_HOME`, which
defaults to `~/.local/bin/stash`.

```bash
git clone https://github.com/shawnohare/stash
cd stash
make install
```

The man page is installed to `${XDG_DATA_HOME}/man/man1`, which `man` will
search provided that `${XDG_DATA_HOME}/../bin` is an element of `$PATH`.

## Uninstall

For a user-level install the provided Makefile can be used
to uninstall the executable and its manpage. 

```bash
make uninstall
```

Otherwise, simply remove the executable and associated manpage.
For example

```bash
rm /usr/local/bin/stash
rm /usr/local/man/man1/stash.1
```

## Testing

The shell scripting testing framework
[bats](https://github.com/bats-core/bats-core) is included as a git submodule. 

```bash
git submodule init
git submodule update
```

```bash
git clone --recurse-submodules https://github.com/shawnohare/stash
make test
```

# Similar Projects

1. The full-featured [GNU stow](https://www.gnu.org/software/stow/) is a 
   pearl script that is more suitable for package management. 

2. [stowsh](https://github.com/williamsmj/stowsh`) is a bash script with
   similar aims to `stash`, but the latter strives for utter simplicity and
   POSIX compliance.

