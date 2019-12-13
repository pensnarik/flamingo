#!/usr/bin/env bash

# Uploads product from JSON file to the server
# If the second argument contains ".json" it is considered to
# be a filename, otherwise it's a SKU and the script will
# add ".json" to get a filename

source=$1
host=$2

if [[ $source == *".json"* ]]; then
	filename=$source
	sku=${source##*/}
	sku=${sku%.json}
else
	filename="$source.json"
	sku=$source
fi

echo "Uploading $sku to $host"
curl --fail -i -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $FLAMINGO_API_KEY" "http://$host/api/product/set" -d @"$filename"
UPLOAD_RESULT=$?
echo "" # server output does not contain a new line character at the end

if [ $UPLOAD_RESULT -ne 0 ]; then
	echo "Upload $sku failed"
	exit 1
fi;

if [ $# -eq 3 ]; then
	echo "Setting visibility for $sku"
	flamingo-set-visibility.sh $host $sku $3
fi;