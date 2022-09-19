#!/bin/sh

# Filename: update-hosts.sh
# Author: George Lesica <george@lesica.com>
# Description: Replaces the HOSTS file with a customized version that blocks
# domains that serve ads and malicious software, creating a backup of the old
# file.

HOSTS_URL="https://raw.githubusercontent.com/t0ny54/blocklistwithregex/main/export/blocklist.txt"
NEW_HOSTS="hosts"
HOSTS_PATH="/etc/mosdns/hosts"

# Grab hosts file
wget -O $NEW_HOSTS $HOSTS_URL

# Backup old hosts file
cp -v $HOSTS_PATH ${HOSTS_PATH}.bak$(date -u +%s)
cp -v $NEW_HOSTS $HOSTS_PATH

# Clean up old downloads
rm $NEW_HOSTS*
