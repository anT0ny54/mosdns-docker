#!/bin/sh

if [ ! -f /etc/mosdns/config.yaml ]; then
	mkdir -p /etc/mosdns/
	cp -u /config.yaml /etc/mosdns/config.yaml
    	cp -u /geosite.dat /etc/mosdns/geosite.dat
    	cp -u /geoip.dat /etc/mosdns/geoip.dat
    	cp -u /hosts /etc/mosdns/hosts
fi

sh /script.sh

sed -i "s|PORT_PLACEHOLDER|${PORT}|;s|PATH_PLACEHOLDER|${DOH_PATH}|" /etc/mosdns/config.yaml

/usr/bin/mosdns start --dir /etc/mosdns
