#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd
email=""
if ! email=$(grep -Po "^email[\s]*=[\s]*\K(.*)$" "config.local"); then
  printf "Missing email\n"
  exit 1
fi
url=""
if ! url=$(grep -Po "^url[\s]*=[\s]*\K(.*)$" "$1"); then
  printf "Missing url\n"
  exit 1
fi
name=""
if ! name=$(grep -Po "^name[\s]*=[\s]*\K(.*)$" "$1"); then
  printf "Missing name\n"
  exit 1
fi

curl -s -k "$url" >"$name-temp"
if [ -f "last/$name-last" ]; then
  diff=$(diff $name-temp last/$name-last)
  if [ "$diff" != "" ]; then
    printf "$diff" | mail -s "The $name was modified" "$email"
    date=$(date '+%Y-%m-%d-%H:%M:%S')
    cp last/$name-last diff/$name-"$date"
  fi
else
  printf "No last file\n"
fi

mv $name-temp last/$name-last
