# syntax=docker/dockerfile:1

# Get Alpine tag from: https://hub.docker.com/_/alpine
FROM alpine:3.17.1 AS builder

ARG ROOT_DIR=/www
ARG HTTP_PORT=8069

LABEL org.opencontainers.image.authors='dreknix <dreknix@proton.me>' \
      org.opencontainers.image.base.name='alpine:3.71.1' \
      org.opencontainers.image.licenses='MIT' \
      org.opencontainers.image.source='https://github.com/dreknix/docker-image-pxe-httpd.git' \
      org.opencontainers.image.title='Docker image for HTTP server in PXE' \
      org.opencontainers.image.url='https://github.com/dreknix/docker-image-pxe-httpd'

# check: https://pkgs.alpinelinux.org/packages?branch=v3.17
RUN apk add --no-cache \
            curl=7.87.0-r1 \
            python3=3.10.10-r0 \
            py3-pip=22.3.1-r1 \
            py3-wheel=0.38.4-r0

WORKDIR /content

COPY content/ .

WORKDIR /

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt; \
    rm -f requirements.txt

COPY entrypoint.sh .
COPY pxe-httpd.py .
COPY config.json .

EXPOSE ${HTTP_PORT}

VOLUME ${ROOT_DIR}

ENV ROOT_DIR=${ROOT_DIR}
ENV HTTP_PORT=${HTTP_PORT}

ENTRYPOINT [ "sh", "-c", "/entrypoint.sh" ]
