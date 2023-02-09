#!/bin/sh

if [ ! -d /ipxe/boot/ ]
then
  mkdir /ipxe/boot
fi
cp -u /ipxe-base/boot/*  /ipxe/boot/

/ipxe-httpd.py
