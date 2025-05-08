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

if [ -z "$1" ] || [ -n "$2" ]; then
  exit 1
fi

latest=$(ls $BACKUP | awk -F '-' '{print $1, $0}' | sort -n | tail -n 1)
num=$(echo "$latest" | awk '{print $1}')
dirname=$(echo "$latest" | awk '{print $2}')

if [ -n "$dirname" ]; then
  extra_opts="$extra_opts --link-dest=$(realpath $BACKUP)/$dirname"
fi

rsync -aAXHv --delete $extra_opts \
    --exclude="/sys/*" \
    --exclude="/dev/*" \
    --exclude="/proc/*" \
    --exclude="/run/*" \
    --exclude="/tmp/*" \
    --exclude="/mnt/*" \
    --exclude="/media/*" \
    --exclude="/var/log/*" \
    --exclude="/var/cache/*" \
    --exclude="/var/tmp/*" \
    --exclude="/lost+found/*" \
    --exclude="/home/*/.cache/*" \
    --exclude="/home/*/data/*" \
    --exclude="/boot/efi/*" \
    --exclude="/backup/*" \
    $TARGET $BACKUP/$((num+1))-$1
