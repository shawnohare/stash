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

@test "stash: dry-run on source dir." {
  bin/stash --dry-run "${SRC}/pkg1" "${TAR}"
  [ ! -e "${TAR}/bin" ]
  [ ! -e "${TAR}/.config/pkg1" ]
}

@test "stash: dry-run on source file" {
  bin/stash --dry-run "${SRC}/pkg1/config1" "${TAR}/config1"
  [ ! -e "${TAR}/config1" ]
}

@test "stash: absolute paths for source and target." {
  bin/stash "${SRC}/pkg1" "${TAR}"
  [ -d "${TAR}/bin" ]
  [ -L "${TAR}/bin/bin1" ]
  [ -L "${TAR}/config1" ]
  [ -L "${TAR}/.config/pkg1" ]
  [ -f "${TAR}/ignore" ] && [ ! -L "${TAR}/ignore" ]
}

@test "stash: link file." {
  bin/stash "${SRC}/pkg1/config1" "${TAR}"
  [ -L "${TAR}/config1" ]
}

# @test "stash: broken symlinked dir deleted." {
#   ln -s "${TAR}/somebaddir" "${TAR}/bin"
#   bin/stash -v "${SRC}/pkg1" "${TAR}" 
#   [ ! -L "${TAR}/bin" ]
#   [ -d "${TAR}/bin" ]
# }

@test "stash: relative paths for source and target." {
  bin/stash "tmp/src/pkg1" "tmp/tar" 
  [ -d "${TAR}/bin" ]
  [ -L "${TAR}/bin/bin1" ]
  [ -L "${TAR}/config1" ]
  [ -L "${TAR}/.config/pkg1" ]
  [ -f "${TAR}/ignore" ] && [ ! -L "${TAR}/ignore" ]
}

@test "stash: force." {
  bin/stash --force "${SRC}/pkg1" "${TAR}" 
  [ -L "${TAR}/ignore" ]
}

@test "stash: idempotence." {
  bin/stash "${SRC}/pkg1" "${TAR}"
  bin/stash "${SRC}/pkg1" "${TAR}"
  [ -d "${TAR}/bin" ]
  [ -L "${TAR}/bin/bin1" ]
  [ -L "${TAR}/config1" ]
  [ -L "${TAR}/.config/pkg1" ]
  [ -f "${TAR}/ignore" ] && [ ! -L "${TAR}/ignore" ]
}

@test "unstash: ensure all package links are removed." {
  bin/stash "${SRC}/pkg1" "${TAR}"
  bin/stash --rm "${SRC}/pkg1" "${TAR}"
  [ ! -e "${TAR}/bin/bin1" ]
  [ ! -e "${TAR}/config1" ]
  [ ! -L "${TAR}/ignore" ]
  [ ! -e "${TAR}/remove" ]
  [ ! -d "${TAR}/bin" ]
  [ ! -d "${TAR}/.config" ]
}

@test "unstash: non-empty dirs shouldn't be deleted." {
  bin/stash "${SRC}/pkg1" "${TAR}" 
  touch "${TAR}/bin/anchor"
  bin/stash --rm "${SRC}/pkg1" "${TAR}" 
  [ -d "${TAR}/bin" ]
}

@test "unstash: idempotence." {
  bin/stash "${SRC}/pkg1" "${TAR}" 
  bin/stash -u "${SRC}/pkg1" "${TAR}" 
  bin/stash -u "${SRC}/pkg1" "${TAR}"
  [ ! -e "${TAR}/bin" ]
  [ ! -e "${TAR}/config1" ]
  [ ! -e "${TAR}/config2" ]
  [ ! -d "${TAR}/.config" ]
  [ ! -L "${TAR}/ignore" ]
  [ ! -e "${TAR}/remove" ]
}

@test "unstash: force." {
  bin/stash "${SRC}/pkg1" "${TAR}" 
  bin/stash -fu "${SRC}/pkg1" "${TAR}" 
  [ ! -e "${TAR}/ignore" ]
}
