#!/usr/bin/env bash

if [ $# -eq 0 ]
then
    echo "Usage: flamingo-get-price.sh <host> <sku>"
    exit 0
fi

host=$1
sku=$2

curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $FLAMINGO_API_KEY" "http://$host/api/get_price" -d "{\"price\": \"$price\", \"sku\": \"$sku\"}"