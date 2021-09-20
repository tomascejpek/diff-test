#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
printf "Run script from $1\n"

email=$(bash ini.sh getValue email config.local.ini)
if [ -z $email ]; then
  printf "Missing email\n"
  exit 1
fi
url=$(bash ini.sh getValue url $1)
if [ -z $url ]; then
  printf "Missing url\n"
  exit 1
fi
name=$(bash ini.sh getValue name $1)
if [ -z $name ]; then
  printf "Missing name\n"
  exit 1
fi
params=$(bash ini.sh getValue params $1)

curl -s -k "$url" >"$name-temp"
if [ -f "last/$name-last" ]; then
  diff=$(diff $params $name-temp last/$name-last)
  if [ "$diff" != "" ]; then
    printf "$diff" | mail -s "The $name was modified" -aFrom:\<cejpek@mzk.cz\> "$email"
    date=$(date '+%Y-%m-%d-%H:%M:%S')
    cp last/$name-last diff/$name-"$date"
  fi
else
  printf "No last file\n"
fi

mv $name-temp last/$name-last
