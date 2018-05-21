#!/usr/bin/env sh

setup() {

  # Previously existing data.
  mkdir -p tmp
  touch tmp/ignore1
  ln -s tmp/ignore1 tmp/remove1

  # Package data. 
  if [ ! -d "tmp/stash" ]; then
    mkdir -p tmp/stash/pkg1/bin
    mkdir -p tmp/stash/pkg2
    touch tmp/stash/pkg1/bin/bin1
    touch tmp/stash/pkg1/config1
    touch tmp/stash/pkg1/ignore1
    touch tmp/stash/pkg1/remove1
    touch tmp/stash/pkg2/config2
  fi
}

teardown() {
  cd tmp
  rm -f ignore1 remove1 config1 config2 bin/bin1
  cd ..
}

@test "stash: absolute paths for source and target." {
  bin/stash -v -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  [ -d "tmp/bin" ]
  [ -L "tmp/bin/bin1" ]
  [ -L "tmp/config1" ]
  [ ! -L "tmp/ignore1" ]
}

@test "stash: relative paths for source and target." {
  bin/stash -v -t "tmp" "tmp/stash/pkg1"
  [ -d "tmp/bin" ]
  [ -L "tmp/bin/bin1" ]
  [ -L "tmp/config1" ]
  [ ! -L "tmp/ignore1" ]
}

@test "stash: default target path." {
  cd tmp/stash
  ../../bin/stash -v pkg1
  cd ../..
  [ -d "tmp/bin" ]
  [ -L "tmp/bin/bin1" ]
  [ -L "tmp/config1" ]
  [ ! -L "tmp/ignore1" ]
}

@test "stash: multiple sources." {
  bin/stash -v -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1" "$(pwd)/tmp/stash/pkg2"
  bin/stash -v -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg2"
  [ -d "tmp/bin" ]
  [ -L "tmp/bin/bin1" ]
  [ -L "tmp/config1" ]
  [ ! -L "tmp/ignore1" ]
}

@test "stash: idempotence." {
  bin/stash -v -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  bin/stash -v -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  [ -d "tmp/bin" ]
  [ -L "tmp/bin/bin1" ]
  [ -L "tmp/config1" ]
  [ ! -L "tmp/ignore1" ]
}

@test "unstash: ensure all package links are removed." {
  bin/stash -v -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  bin/stash -v -d -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  [ -d "tmp/bin" ]
  [ ! -e "tmp/bin/bin1" ]
  [ ! -e "tmp/config1" ]
  [ ! -L "tmp/ignore1" ]
  [ ! -e "tmp/remove1" ]
}

@test "unstash: idempotence." {
  bin/stash -v -d "tmp/stash/pkg1"
  bin/stash -v -d "tmp/stash/pkg1"
  [ -d "tmp/bin" ]
  [ ! -e "tmp/bin/bin1" ]
  [ ! -e "tmp/config1" ]
  [ ! -L "tmp/ignore1" ]
  [ ! -e "tmp/remove1" ]
}
