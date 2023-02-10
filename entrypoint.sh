#!/bin/sh

if [ ! -d "${ROOT_DIR}/boot" ]
then
  mkdir "${ROOT_DIR}/boot"
fi
cp -u /content/boot/*  "${ROOT_DIR}/boot"

/pxe-httpd.py
