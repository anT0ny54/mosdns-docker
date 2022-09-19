#!/bin/sh

HOSTS_URL="https://raw.githubusercontent.com/t0ny54/blocklistwithregex/main/export/blocklist.txt"
NEW_HOSTS="blocklist.txt"

# Grab hosts file
wget -O $NEW_HOSTS $HOSTS_URL
