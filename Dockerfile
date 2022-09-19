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

ADD hosts /hosts
COPY hosts /hosts
ADD install_geodata.sh /install_geodata.sh
COPY install_geodata.sh /install_geodata.sh
ADD install_hosts.sh /install_hosts.sh
COPY install_hosts.sh /install_hosts.sh

COPY --from=builder /root/mosdns/mosdns /usr/bin/

RUN apk add --no-cache ca-certificates curl \
	&& mkdir /etc/mosdns
ADD entrypoint.sh /entrypoint.sh
ADD config.yaml /config.yaml
ADD config.yaml /etc/mosdns/config.yaml
ADD https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat /geoip.dat
ADD https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat /geosite.dat
ADD hosts /hosts
COPY hosts /hosts
ENV PORT=8080
ENV DOH_PATH=/dns-query
EXPOSE 8080
VOLUME /etc/mosdns
EXPOSE 53/udp 53/tcp
RUN chmod +x /etc/mosdns/geodata.sh
RUN chmod +x /etc/mosdns/install_hosts.sh
RUN chmod +x /entrypoint.sh
RUN chmod +x /etc/mosdns/entrypoint.sh
ENTRYPOINT [ "sh","/etc/mosdns/entrypoint.sh" ]
