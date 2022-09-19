#!/bin/sh

if [ ! -f /etc/mosdns/install_geodata.sh ]; then
	mkdir -p /etc/mosdns/
	cp -u /config.yaml /etc/mosdns/config.yaml
    	cp -u /geosite.dat /etc/mosdns/geosite.dat
    	cp -u /geoip.dat /etc/mosdns/geoip.dat
    	cp -u /hosts /etc/mosdns/hosts
    	cp -u /hosts /etc/mosdns/install_geodata.sh
fi

sh /etc/mosdns/install_geodata.sh

sed -i "s|PORT_PLACEHOLDER|${PORT}|;s|PATH_PLACEHOLDER|${DOH_PATH}|" /etc/mosdns/config.yaml

exec mosdns start -d /etc/mosdns
