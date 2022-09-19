FROM --platform=${TARGETPLATFORM} golang:alpine as builder
ARG CGO_ENABLED=0
ARG TAG
ARG REPOSITORY

WORKDIR /root
RUN apk add --update git \
	&& git clone https://github.com/${REPOSITORY} mosdns \
	&& cd ./mosdns \
	&& git fetch --all --tags \
	&& git checkout tags/${TAG} \
	&& go build -ldflags "-s -w -X main.version=${TAG}" -trimpath -o mosdns

FROM --platform=${TARGETPLATFORM} alpine:latest

COPY --from=builder /root/mosdns/mosdns /usr/bin/

RUN apk add --no-cache ca-certificates curl \
	&& mkdir /etc/mosdns
ADD install_geodata.sh /etc/mosdns/install_geodata.sh
COPY install_geodata.sh /etc/mosdns/install_geodata.sh
ADD entrypoint.sh /etc/mosdns/entrypoint.sh
ADD config.yaml /etc/mosdns/config.yaml
ADD https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat /etc/mosdns/geoip.dat
ADD https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat /etc/mosdns/geosite.dat
ADD blocklist.txt /etc/mosdns/blocklist.txt
COPY blocklist.txt /etc/mosdns/blocklist.txt
ENV PORT=8080
ENV DOH_PATH=/dns-query
EXPOSE 8080
VOLUME /etc/mosdns
EXPOSE 53/udp 53/tcp
RUN chmod +x /etc/mosdns/install_geodata.sh
RUN chmod +x /etc/mosdns/entrypoint.sh
ENTRYPOINT [ "sh","/etc/mosdns/entrypoint.sh" ]
