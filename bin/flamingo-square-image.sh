#!/usr/bin/env bash

filename=$1

# Get trim box w, h, x, y
IFS=" x+" read w h x y < <(convert "$filename" -format "%w x %h" info:)

# Get longest side
if [ $w -eq $h ]; then
	exit 0
fi;

longest=$w
[ $h -gt $longest ] && longest=$h

tmp_filename="${filename}.tmp"
convert "$filename" -background white -gravity center -extent ${longest}x${longest} "$tmp_filename"
mv "$tmp_filename" "$filename"

echo "$filename has been extended to $longest px"
