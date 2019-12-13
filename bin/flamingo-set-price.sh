#!/bin/bash

if [ $# -eq 0 ]
then
    echo "Usage: flamingo-set-price.sh <host> <sku> <price>"
    exit 0
fi

host=$1
sku=$2
price=$3

curl -i -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $FLAMINGO_API_KEY" "http://$host/api/set_price" -d "{\"price\": \"$price\", \"sku\": \"$sku\"}"