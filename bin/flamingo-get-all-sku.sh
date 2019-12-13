#!/usr/bin/env bash

# Script prints all SKUs from given database, now it uses hardcoded
# host and port, but may be updated in future

# Usage: flamingo-get-all-sku.sh <domain>

if [ $# -eq 0 ]
then
    echo "Usage: flamingo-get-all-sku.sh <domain>"
    exit 1
fi

domain=$1

dsn=$(flamingo-get-database.sh $domain)

if [[ $dsn = "" ]]; then
	echo "Could not find database DSN for shop domain $domain"
	exit 1
fi;

psql -Aqt -c "select sku from shop.product order by sku" $dsn