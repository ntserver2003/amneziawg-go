FROM golang:1.24.4 as awg
COPY . /awg
WORKDIR /awg
RUN go mod download && \
    go mod verify && \
    go build -ldflags '-linkmode external -extldflags "-fno-PIC -static"' -v -o /usr/bin

FROM alpine:3.23
ARG AWGTOOLS_RELEASE="1.0.20260119"
ARG AWGTOOLS_PLATFORM="arm64"


RUN apk --no-cache add iproute2 iptables bash && \
    cd /usr/bin/ && \
    wget https://github.com/ntserver2003/amneziawg-tools/releases/download/v${AWGTOOLS_RELEASE}/alpine-3.23-${AWGTOOLS_PLATFORM}-amneziawg-tools.zip && \
    unzip -j alpine-3.23-${AWGTOOLS_PLATFORM}-amneziawg-tools.zip && \
    chmod +x /usr/bin/awg /usr/bin/awg-quick && \
    ln -s /usr/bin/awg /usr/bin/wg && \
    ln -s /usr/bin/awg-quick /usr/bin/wg-quick
COPY --from=awg /usr/bin/amneziawg-go /usr/bin/amneziawg-go
