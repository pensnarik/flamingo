#!/usr/bin/env bash

# Uploads all files from the specified directory
# to the server considering each file is a JSON file
# with a product

directory=${1%/}
host=$2

for file in $directory/*.json
do
	sku=${file##*/}
	sku=${sku%.json}
    flamingo-upload.sh "$directory/$sku.json" $host
done
