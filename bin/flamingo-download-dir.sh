#!/bin/bash

host=$1
directory=$2

mkdir -p "$directory"

while read sku;
do
    echo $sku;
    curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $FLAMINGO_API_KEY" "http://$host/api/product/$sku" | jq '.' > "./$directory/$sku.json"
done <&0
