#!/usr/bin/env sh

setup() {

  # Previously existing data.
  mkdir -p tmp
  touch tmp/ignore
  ln -s -f tmp/ignore tmp/remove

  # Package data. 
  if [ ! -d "tmp/stash" ]; then
    mkdir -p tmp/stash/pkg1/bin
    mkdir -p tmp/stash/pkg1/.config/empty1/empty11
    mkdir -p tmp/stash/pkg2
    touch tmp/stash/pkg1/bin/bin1
    touch tmp/stash/pkg1/.config/pkg1
    touch tmp/stash/pkg1/config1
    touch tmp/stash/pkg1/ignore
    touch tmp/stash/pkg1/remove
    touch tmp/stash/pkg2/config2
  fi
}

teardown() {
  # rm -rf tmp
  cd tmp
  rm -rf ignore remove config1 config2 bin/bin1 .config
  cd ..
}

@test "stash: absolute paths for source and target." {
  bin/stash -v -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  [ -d "tmp/bin" ]
  [ -L "tmp/bin/bin1" ]
  [ -L "tmp/config1" ]
  [ -L "tmp/.config/pkg1" ]
  [ -f "tmp/ignore" ] && [ ! -L "tmp/ignore" ]
}

@test "stash: relative paths for source and target." {
  bin/stash -v -t "tmp" "tmp/stash/pkg1"
  [ -d "tmp/bin" ]
  [ -L "tmp/bin/bin1" ]
  [ -L "tmp/config1" ]
  [ -L "tmp/.config/pkg1" ]
  [ -f "tmp/ignore" ] && [ ! -L "tmp/ignore" ]
}

@test "stash: default target path." {
  cd tmp/stash
  ../../bin/stash -v pkg1
  cd ../..
  [ -d "tmp/bin" ]
  [ -L "tmp/bin/bin1" ]
  [ -L "tmp/config1" ]
  [ -L "tmp/.config/pkg1" ]
  [ -f "tmp/ignore" ] && [ ! -L "tmp/ignore" ]
}

@test "stash: force." {
  bin/stash -v -f -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  [ -d "tmp/bin" ]
  [ -L "tmp/bin/bin1" ]
  [ -L "tmp/config1" ]
  [ -L "tmp/.config/pkg1" ]
  [ -L "tmp/ignore" ]
}

@test "stash: multiple sources." {
  bin/stash -v -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1" "$(pwd)/tmp/stash/pkg2"
  bin/stash -v -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg2"
  [ -d "tmp/bin" ]
  [ -L "tmp/bin/bin1" ]
  [ -L "tmp/config1" ]
  [ -L "tmp/.config/pkg1" ]
  [ ! -L "tmp/ignore" ]
}

@test "stash: idempotence." {
  bin/stash -v -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  bin/stash -v -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  [ -d "tmp/bin" ]
  [ -L "tmp/bin/bin1" ]
  [ -L "tmp/config1" ]
  [ -L "tmp/.config/pkg1" ]
  [ ! -L "tmp/ignore" ]
}

@test "unstash: ensure all package links are removed." {
  bin/stash -v -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  bin/stash -v -D -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  [ ! -e "tmp/bin/bin1" ]
  [ ! -e "tmp/config1" ]
  [ ! -L "tmp/ignore" ]
  [ ! -e "tmp/remove" ]
  [ ! -d "tmp/bin" ]
  [ ! -d "tmp/.config" ]
}

@test "unstash: non-empty dirs shouldn't be removed." {
  bin/stash -v -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  touch tmp/bin/anchor
  bin/stash -v -D -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  [ ! -e "tmp/bin/bin1" ]
  [ ! -e "tmp/config1" ]
  [ ! -d "tmp/.config" ]
  [ ! -L "tmp/ignore" ]
  [ ! -e "tmp/remove" ]
  [ -d "tmp/bin" ]
  rm tmp/bin/anchor
}

@test "unstash: multiple sources." {
  bin/stash -v -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1" "$(pwd)/tmp/stash/pkg1"
  bin/stash -v -D -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1" "$(pwd)/tmp/stash/pkg1"
  [ ! -d "tmp/bin" ]
  [ ! -e "tmp/bin/bin1" ]
  [ ! -e "tmp/config1" ]
  [ ! -d "tmp/.config" ]
  [ ! -e "tmp/config2" ]
  [ ! -L "tmp/ignore" ]
  [ ! -e "tmp/remove" ]
}

@test "unstash: idempotence." {
  bin/stash -v -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  bin/stash -v -D -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  bin/stash -v -D -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  [ ! -e "tmp/bin/bin1" ]
  [ ! -e "tmp/config1" ]
  [ ! -d "tmp/.config" ]
  [ ! -L "tmp/ignore" ]
  [ ! -e "tmp/remove" ]
  [ ! -d "tmp/bin" ]
}

@test "unstash: force." {
  bin/stash -v -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  bin/stash -v -D -f -t "$(pwd)/tmp" "$(pwd)/tmp/stash/pkg1"
  [ ! -e "tmp/bin/bin1" ]
  [ ! -e "tmp/config1" ]
  [ ! -d "tmp/.config" ]
  [ ! -e "tmp/ignore" ]
  [ ! -e "tmp/remove" ]
  [ ! -d "tmp/bin" ]
}
