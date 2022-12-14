#!/usr/bin/env sh

HOSTS_URL="https://raw.githubusercontent.com/t0ny54/blocklistfamilywithregex/main/export/blocklist.txt"
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"

# Grab hosts file
wget $HOSTS_URL

cp hosts ./content

# Grab hosts file
wget $GEOIP_URL

cp geoip.dat ./content

# Grab hosts file
wget $GEOSITE_URL

cp geosite.dat ./content
