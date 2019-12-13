#!/bin/bash

if [ $# -eq 0 ]
then
    echo "Usage: flamingo-set-visibility.sh <host> <sku> <is_visible>"
    exit 0
fi

host=$1
sku=$2
is_visible=$3

curl -i -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $FLAMINGO_API_KEY" "http://$host/api/product/$sku/set_visibility" -d "{\"is_visible\": \"$is_visible\"}"
echo ""