#!/usr/bin/env sh

unset STASH_TARGET
readonly TAR="$(pwd)/tmp/tar"
readonly SRC="$(pwd)/tmp/src"

setup() {

  # Previously existing data.
  mkdir -p "${TAR}/.bin" 
  touch "${TAR}/ignore"
  ln -s -f "${TAR}/ignore" "${TAR}/remove"

  # Package data. Should be session wide.
  if [ ! -d "${SRC}" ]; then
    mkdir -p "${SRC}/pkg1/bin"
    mkdir -p "${SRC}/pkg1/.config/empty1/empty11"
    mkdir -p "${SRC}/pkg2"
    touch "${SRC}/pkg1/bin/bin1"
    touch "${SRC}/pkg1/.config/pkg1"
    touch "${SRC}/pkg1/config1"
    touch "${SRC}/pkg1/ignore"
    touch "${SRC}/pkg1/remove"
    touch "${SRC}/pkg2/config2"
  fi
}

teardown() {
  rm -rf "${TAR}" 
}

@test "stash: absolute paths for source and target." {
  bin/stash -v -t "${TAR}" "${SRC}/pkg1"
  [ -d "${TAR}/bin" ]
  [ -L "${TAR}/bin/bin1" ]
  [ -L "${TAR}/config1" ]
  [ -L "${TAR}/.config/pkg1" ]
  [ -f "${TAR}/ignore" ] && [ ! -L "${TAR}/ignore" ]
}

@test "stash: broken symlinked dir deleted." {
  ln -s "${TAR}/somebaddir" "${TAR}/bin"
  bin/stash -v -t "${TAR}" "${SRC}/pkg1"
  [ ! -L "${TAR}/bin" ]
  [ -d "${TAR}/bin" ]
}

@test "stash: relative paths for source and target." {
  bin/stash -v -t "tmp/tar" "tmp/src/pkg1"
  [ -d "${TAR}/bin" ]
  [ -L "${TAR}/bin/bin1" ]
  [ -L "${TAR}/config1" ]
  [ -L "${TAR}/.config/pkg1" ]
  [ -f "${TAR}/ignore" ] && [ ! -L "${TAR}/ignore" ]
}

@test "stash: default target path." {
  cd tmp/src
  ../../bin/stash -v pkg1
  cd ..
  [ -d "bin" ]
  [ -L "bin/bin1" ]
  [ -L "config1" ]
  [ -L ".config/pkg1" ]
  [ -L "ignore" ]
  cd ..
  rm -rf tmp
}

@test "stash: force." {
  bin/stash -v -f -t "${TAR}" "${SRC}/pkg1"
  [ -L "${TAR}/ignore" ]
}

@test "stash: multiple sources." {
  bin/stash -v -t "${TAR}" "${SRC}/pkg1" "${SRC}/pkg2"
  [ -L "${TAR}/config1" ]
  [ -L "${TAR}/config2" ]
}

@test "stash: idempotence." {
  bin/stash -v -t "${TAR}" "${SRC}/pkg1"
  bin/stash -v -t "${TAR}" "${SRC}/pkg1"
  [ -d "${TAR}/bin" ]
  [ -L "${TAR}/bin/bin1" ]
  [ -L "${TAR}/config1" ]
  [ -L "${TAR}/.config/pkg1" ]
  [ -f "${TAR}/ignore" ] && [ ! -L "${TAR}/ignore" ]
}

@test "unstash: ensure all package links are removed." {
  bin/stash -v -t "${TAR}" "${SRC}/pkg1"
  bin/stash -v -D -t "${TAR}" "${SRC}/pkg1"
  [ ! -e "${TAR}/bin/bin1" ]
  [ ! -e "${TAR}/config1" ]
  [ ! -L "${TAR}/ignore" ]
  [ ! -e "${TAR}/remove" ]
  [ ! -d "${TAR}/bin" ]
  [ ! -d "${TAR}/.config" ]
}

@test "unstash: non-empty dirs shouldn't be deleted." {
  bin/stash -v -t "${TAR}" "${SRC}/pkg1"
  touch "${TAR}/bin/anchor"
  bin/stash -v -D -t "${TAR}" "${SRC}/pkg1"
  [ -d "${TAR}/bin" ]
}

@test "unstash: multiple sources." {
  bin/stash -v -t "${TAR}" "${SRC}/pkg1" "${SRC}/pkg2"
  bin/stash -v -D -t "${TAR}" "${SRC}/pkg1" "${SRC}/pkg2"
  [ ! -e "${TAR}/bin" ]
  [ ! -e "${TAR}/config1" ]
  [ ! -e "${TAR}/config2" ]
  [ ! -d "${TAR}/.config" ]
  [ ! -L "${TAR}/ignore" ]
  [ ! -e "${TAR}/remove" ]
}

@test "unstash: idempotence." {
  bin/stash -v -t "${TAR}" "${SRC}/pkg1"
  bin/stash -v -D -t "${TAR}" "${SRC}/pkg1"
  bin/stash -v -D -t "${TAR}" "${SRC}/pkg1"
  [ ! -e "${TAR}/bin" ]
  [ ! -e "${TAR}/config1" ]
  [ ! -e "${TAR}/config2" ]
  [ ! -d "${TAR}/.config" ]
  [ ! -L "${TAR}/ignore" ]
  [ ! -e "${TAR}/remove" ]
}

@test "unstash: force." {
  bin/stash -v -t "${TAR}" "${SRC}/pkg1"
  bin/stash -v -D -f -t "${TAR}" "${SRC}/pkg1"
  [ ! -e "${TAR}/ignore" ]
}
