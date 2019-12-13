#!/usr/bin/env bash

# Gets skus from list of files based on filenames

if [ $# -eq 0 ]
then
    echo "Usage: flamingo-sku-from-dir.sh dir"
    exit 0
fi

for file in $1/*.json
do
	sku=${file##*/}
	sku=${sku%.json}
	echo $sku
done;