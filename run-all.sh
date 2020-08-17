#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null

for file in "ini"/*
do
  ./diff-test.sh "$file"
done
