#!/bin/bash

host=$1
id=$2

curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $FLAMINGO_API_KEY" "http://$host/api/category/$id"
