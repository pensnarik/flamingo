#!/usr/bin/env bash

domain=$1
directory=$2

if [ ! $# -eq 2 ]; then
	echo "Usage: flamingo-download-categories.sh <domain> <directory>"
	exit 1
fi;

mkdir -p "$directory"

while read id;
do
    echo "Get category $id..."
    flamingo-category-get.sh $domain $id > "$directory/category-$id.json"
done <&0
