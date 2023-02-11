#!/bin/sh

if [ ! -d "${ROOT_DIR}/boot" ]
then
  mkdir "${ROOT_DIR}/boot"
fi
cp -u /content/boot/*  "${ROOT_DIR}/boot"

###
### Download ISO images
###
if [ ! -d "${ROOT_DIR}/iso/" ]
then
  mkdir "${ROOT_DIR}/iso/"
fi

# Install memdisk
if [ ! -f "${ROOT_DIR}/iso/memdisk" ]
then
  curl --output syslinux-5.10.zip https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/syslinux-5.10.zip
  unzip syslinux-5.10.zip memdisk/memdisk
  mv memdisk/memdisk "${ROOT_DIR}/iso/memdisk"
  rmdir memdisk/
  rm syslinux-5.10.zip
fi

# Install Memtest86+
if [ ! -f "${ROOT_DIR}/iso/mt86plus_6.10_64.iso" ]
then
  curl --output mt86plus_6.10_64.iso.zip https://memtest.org/download/v6.10/mt86plus_6.10_64.iso.zip
  unzip mt86plus_6.10_64.iso.zip mt86plus_6.10_64.iso
  mv mt86plus_6.10_64.iso "${ROOT_DIR}/iso/mt86plus_6.10_64.iso"
  rm mt86plus_6.10_64.iso.zip
fi
if [ ! -f "${ROOT_DIR}/iso/memtest64.efi" ]
then
  curl --output mt86plus_6.10.binaries.zip https://memtest.org/download/v6.10/mt86plus_6.10.binaries.zip
  unzip mt86plus_6.10.binaries.zip memtest64.efi
  mv memtest64.efi "${ROOT_DIR}/iso/memtest64.efi"
  rm mt86plus_6.10.binaries.zip
fi

# Install SystemRescue
if [ ! -f "${ROOT_DIR}/iso/systemrescue" ]
then
  mkdir "${ROOT_DIR}/iso/systemrescue"
  # use '-L' to follow redirects from SourceForge
  curl --output systemrescue-9.06-amd64.iso -L https://sourceforge.net/projects/systemrescuecd/files/sysresccd-x86/9.06/systemrescue-9.06-amd64.iso/download
  7z x systemrescue-9.06-amd64.iso "-o${ROOT_DIR}/iso/systemrescue"
  rm systemrescue-9.06-amd64.iso
fi

# Install FreeDOS
if [ ! -f "${ROOT_DIR}/iso/freedos_live_1_3.iso" ]
then
  curl --output FD13-LiveCD.zip https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.3/official/FD13-LiveCD.zip
  unzip FD13-LiveCD.zip FD13LIVE.iso
  mv FD13LIVE.iso "${ROOT_DIR}/iso/freedos_live_1_3.iso"
  rm FD13-LiveCD.zip
fi

###
### Start HTTP server
###
/pxe-httpd.py
