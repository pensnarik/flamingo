#!/bin/bash

psql -U postgres -f drop.sql -v database=parsing
psql -U postgres -f install.sql -v database=parsing
