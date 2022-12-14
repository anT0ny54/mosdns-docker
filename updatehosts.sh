#!/usr/bin/env sh

HOSTS_URL="https://raw.githubusercontent.com/t0ny54/blocklistfamilywithregex/main/export/blocklist.txt"
NEW_HOSTS="hosts"
HOSTS_PATH="./content/hosts"

# Grab hosts file
wget -O $NEW_HOSTS $HOSTS_URL

cp -v $NEW_HOSTS $HOSTS_PATH
