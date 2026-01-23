FROM --platform=$BUILDPLATFORM golang:1.24.4 as awg
ARG TARGETOS
ARG TARGETARCH
COPY . /awg
WORKDIR /awg
RUN go mod download && \
    go mod verify && \
    CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -v -o /usr/bin/amneziawg-go

FROM alpine:3.23
ARG AWGTOOLS_RELEASE="1.0.20260119"
ARG TARGETARCH


RUN apk --no-cache add iproute2 iptables bash && \
    cd /usr/bin/ && \
    wget https://github.com/ntserver2003/amneziawg-tools/releases/download/v${AWGTOOLS_RELEASE}/alpine-3.23-${TARGETARCH}-amneziawg-tools.zip && \
    unzip -j alpine-3.23-${TARGETARCH}-amneziawg-tools.zip && \
    rm alpine-3.23-${TARGETARCH}-amneziawg-tools.zip && \
    chmod +x /usr/bin/awg /usr/bin/awg-quick && \
    ln -s /usr/bin/awg /usr/bin/wg && \
    ln -s /usr/bin/awg-quick /usr/bin/wg-quick
COPY --from=awg /usr/bin/amneziawg-go /usr/bin/amneziawg-go
