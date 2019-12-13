#!/bin/bash

filename=$1
host=$2

curl -i -X POST -s -H "Content-Type: application/json" -H "Authorization: Bearer $FLAMINGO_API_KEY" "http://$host/api/category" -d @"$filename"
