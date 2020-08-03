#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd
email=""
if email=$(grep -Po "^email[\s]*=[\s]*\K(.*)$" "config.local"); then
  curl -s -k "http://aleph.nkp.cz/web/cpk/skc_links" >skc-links-temp
  if [ -f "skc-links-old" ]; then
    DIFF=$(diff skc-links-temp skc-links-old)
    if [ "$DIFF" != "" ]; then
      printf "The skc-links was modified\n\n%s" "$DIFF" | mail -s "The skc-links was modified" "$email"
      date=$(date '+%Y-%m-%d-%H:%M:%S')
      cp skc-links-old skc-links-"$date"
    fi
  else
    printf "No old file\n"
  fi
  mv skc-links-temp skc-links-old
else
  printf "Missing configuration\n"
  exit 1
fi
