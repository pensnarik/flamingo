#!/usr/bin/env bash

# Usage: flamingo-download-shop.sh <domain> <dir>

# Downloads all exportable content of the specified shop
# into a directory. Directory shouldn't be exists.

domain=$1
dir=$2

if [ -d $dir ]; then
	echo "Output directory already exists"
	exit 1
fi;

mkdir -p $dir

flamingo-get-all-sku.sh $domain | flamingo-download-dir.sh $domain $dir
flamingo-categories-get.sh $domain | flamingo-download-categories.sh $domain $dir