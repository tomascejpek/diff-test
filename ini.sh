#!/bin/bash

iniFile="config.local.ini"

getValue() {
  if grep -P "^$1 ?= ?" $2 >/dev/null; then
    grep -oP "^$1 ?= ?\K.*" $2 | xargs
  else
    printf "Unknown option\n"
    exit 1
  fi
}

"$@"
