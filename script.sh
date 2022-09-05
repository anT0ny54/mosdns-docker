#!/bin/sh

LOGGER_TAG=v2ray-geodata-updater

log () {
  echo $@
  logger -t $LOGGER_TAG "$@"
}

log "fetching geoip url..."
GEOIP_URL=$(curl -sL https://api.github.com/repos/Loyalsoldier/v2ray-rules-dat/releases/latest | jq -r '.assets[].browser_download_url')
log "geoip url: $GEOIP_URL"

log "fetching geosite url..."
GEOSITE_URL=$(curl -sL https://api.github.com/repos/Loyalsoldier/v2ray-rules-dat/releases/latest | jq -r '.assets[].browser_download_url')
log "geosite url: $GEOSITE_URL"

GEOIP_PATH=/etc/mosdns/geoip.dat
GEOSITE_PATH=/etc/mosdns/geosite.dat

log "geoip.dat will be saved as $GEOIP_PATH"
log "geosite.dat will be saved as $GEOSITE_PATH"

log "downloading geoip.dat..."
curl -o /tmp/geoip.dat -sL $GEOIP_URL
if [ $? -ne 0 ]; then
  log "failed to download latest geoip.dat, not updating!"
else
  mv /tmp/geoip.dat $GEOIP_PATH
  log "v2ray geoip.dat updated"
fi

log "downloading geosite.dat..."
curl -o /tmp/geosite.dat -sL $GEOSITE_URL
if [ $? -ne 0 ]; then
  log "failed to download latest geosite.dat, not updating!"
else
  mv /tmp/geosite.dat $GEOSITE_PATH
  log "v2ray geosite.dat updated"
fi
