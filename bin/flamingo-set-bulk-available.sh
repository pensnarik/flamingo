#!/bin/bash

host=$1

curl -i -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $FLAMINGO_API_KEY" "http://$host/api/set_available_bulk" -d "[{\"sku\": \"nokia-101\", \"available\": 100}]"