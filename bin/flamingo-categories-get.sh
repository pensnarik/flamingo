#!/usr/bin/env bash

# Returns IDs of all categories in shop

host=$1

curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $FLAMINGO_API_KEY" "http://$host/api/categories" | jq '.result[].id'
