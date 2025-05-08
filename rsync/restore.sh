#!/bin/sh

TARGET="/mnt/system/"
BACKUP="/mnt/backup/bookworm"

extra_opts=""

while getopts "n" opt; do
  case "$opt" in
    n) extra_opts="$extra_opts -n";;
    \?) exit 1;;
  esac
done

shift $((OPTIND -1))

if [ -n "$2" ]; then
  exit 1
fi

latest=$(ls $BACKUP | awk -F '-' '{print $1, $0}' | sort -n | tail -n 1 | awk '{print $2}')
if [ -z "$1" ]; then
  src=$latest
else
  src=$1
fi

rsync -aAXHv --delete $extra_opts $BACKUP/$src/ $TARGET
