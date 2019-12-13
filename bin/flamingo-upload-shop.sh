#!/usr/bin/env bash

# Uploads contents of the specified directory to shop

directory=$1
domain=$2
visibility=$3

if [ ! $# -gt 1 ]; then
	echo "Usage: flamingo-upload-shop.sh <directory> <domain> <visibility>"
	exit 1
fi;

if [ ! -d $directory ]; then
	echo "Source directory does not exist"
	exit 1
fi;

for file in $directory/*.json; do
	basename=${file##*/}
	if [[ $basename =~ ^category-.* ]]; then
		flamingo-category-set.sh $file $domain
	else
		flamingo-upload.sh $file $domain $visibility
	fi;
done;