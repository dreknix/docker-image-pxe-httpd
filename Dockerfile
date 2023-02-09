# syntax=docker/dockerfile:1

# Get Alpine tag from: https://hub.docker.com/_/alpine
FROM alpine:3.17.1 AS builder

# check: https://pkgs.alpinelinux.org/packages?branch=v3.17
RUN apk add --no-cache \
            python3=3.10.10-r0 \
            py3-pip=22.3.1-r1 \
            py3-wheel=0.38.4-r0

WORKDIR /

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt; \
    rm -f requirements.txt

COPY ipxe-httpd.py .
COPY config.json .

EXPOSE 8080

VOLUME /ipxe

ENTRYPOINT [ "/ipxe-httpd.py" ]
