#!/bin/bash

host=$1

curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $FLAMINGO_API_KEY" "http://$host/api/product_view_stat"
