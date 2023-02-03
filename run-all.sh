#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null || exit

ini=$1

if [ -z "$ini" ]; then
  ini="ini"
fi

for file in "$ini"/*; do
  ./diff-test.sh "$file"
done
