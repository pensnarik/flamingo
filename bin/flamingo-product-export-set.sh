#!/usr/bin/env bash

if [ $# -eq 0 ]
then
    echo "Usage: flamingo-product-export-set.sh <host> <module> <sku> <is_exported>"
    exit 0
fi

host=$1
module=$2
sku=$3
is_exported=$4

curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $FLAMINGO_API_KEY" "http://$host/api/product/${sku}/set_exported" -d "{\"module\": \"$module\", \"is_exported\": \"$is_exported\"}"