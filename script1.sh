#!/bin/sh

set -e

# crontab 0 */2 * * *  /path/to/update_hosts_block.sh

if [ -f /etc/mosdns/hosts ]
  then
    echo "Original hosts file found."
  else
    cp /etc/hosts /etc/hosts.original
fi

cp /etc/hosts.original /etc/hosts

wget -O /etc/mosdns/hosts https://raw.githubusercontent.com/t0ny54/blocklistwithregex/main/export/blocklist.txt

exit 0;
