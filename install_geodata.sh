#!/bin/sh

# This shell script to install the latest release of geoip.dat and geosite.dat:

# The URL of the script project is:
# https://github.com/v2fly/fhs-install-v2ray

# Modified by wy580477 for customized container <https://github.com/wy580477>

# You can set this variable whatever you want in shell session right before running this script by issuing:
# export DAT_PATH='/usr/local/lib/v2ray'

DAT_PATH=${DAT_PATH:-/etc/mosdns}

DOWNLOAD_LINK_GEOIP="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
DOWNLOAD_LINK_GEOSITE="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
DOWNLOAD_LINK_HOSTS="https://raw.githubusercontent.com/t0ny54/blocklistwithregex/main/export/blocklist.txt"
file_hosts='blocklist.txt'
file_ip='geoip.dat'
file_dlc='geosite.dat'
dir_tmp="$(mktemp -d)"

download_files() {
  if ! wget -q --no-cache -O "${dir_tmp}/${2}" "${1}"; then
    echo 'error: Download failed! Please check your network or try again.'
    exit 1
  fi
  if ! wget -q --no-cache -O "${dir_tmp}/${2}.sha256sum" "${1}.sha256sum"; then
    echo 'error: Download failed! Please check your network or try again.'
    exit 1
  fi
}

check_sum() {
  (
    cd "${dir_tmp}" || exit
    for i in "${dir_tmp}"/*.sha256sum; do
      if ! sha256sum -c "${i}"; then
        echo 'error: Check failed! Please check your network or try again.'
        exit 1
      fi
    done
  )
}

install_file() {
  mkdir -p ${DAT_PATH} 2>/dev/null
  cp -af "${dir_tmp}"/${file_dlc} "${DAT_PATH}"/${file_dlc}
  cp -af "${dir_tmp}"/${file_ip} "${DAT_PATH}"/${file_ip}
  rm -r "${dir_tmp}"
}

main() {
  echo "Updating geoip.dat, geosite.dat and hosts"
  download_files $DOWNLOAD_LINK_GEOIP $file_ip
  download_files $DOWNLOAD_LINK_GEOSITE $file_dlc
  wget -O /etc/mosdns/blocklist.txt $DOWNLOAD_LINK_HOSTS
  check_sum
  install_file
}

main "$@"
