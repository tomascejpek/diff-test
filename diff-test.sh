#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 || exit
printf "Run script from $1\n"

email=$(bash ini.sh getValue email config.local.ini)
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
sort=$(bash ini.sh getValue sort $1)
if [ -z "$sort" ]; then
  sort=0
fi
enable=$(bash ini.sh getValue enable $1)
if [ -z "$enable" ] || [ "$enable" == 0 ]; then
  echo "Not enabled!"
  exit 1
fi
params=$(bash ini.sh getValue params $1)
grepParams=$(bash ini.sh getValue grep $1)

curl -s -k "$url" >"$name-temp"
if [ -n "$grepParams" ]; then
  grep $grepParams $name-temp >$name-temp1
  if [ "$sort" == "1" ]; then
    sort $name-temp1 >$name-temp
    rm $name-temp1
  else
    mv $name-temp1 $name-temp
  fi
fi

if [ -f "last/$name-last" ]; then
  diff=$(diff $params $name-temp last/$name-last)
  if [ "$diff" != "" ]; then
    date=$(date '+%Y-%m-%d-%H:%M:%S')
    printf "0a\n%s\n\n.\nx\n" "$diff" | ex "diff-history/$name"
    printf "0a\n%s\n.\nx\n" "$date" | ex "diff-history/$name"
    if [ -n "$email" ]; then
      printf "$diff" | mail -s "The $name was modified" -aFrom:\<cejpek@mzk.cz\> "$email"
    fi
    cp last/$name-last diff/$name-"$date"
  fi
else
  printf "No last file\n"
fi

mv $name-temp last/$name-last
