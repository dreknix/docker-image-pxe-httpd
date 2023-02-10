# syntax=docker/dockerfile:1

# Get Alpine tag from: https://hub.docker.com/_/alpine
FROM alpine:3.17.1 AS builder

ARG ROOT_DIR=/www
ARG HTTP_PORT=8069

# check: https://pkgs.alpinelinux.org/packages?branch=v3.17
RUN apk add --no-cache \
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
