#!/bin/sh

### Copy all iPXE menu files
if [ ! -d "${ROOT_DIR}/boot" ]
then
  mkdir "${ROOT_DIR}/boot"
fi
cp /content/boot/*  "${ROOT_DIR}/boot"


### Download ISO images
ISO_DIR="${ROOT_DIR}/iso"
if [ ! -d "${ISO_DIR}/" ]
then
  mkdir "${ISO_DIR}/"
fi

download() {
  if [ $# -eq 0 ]
  then
    echo "function download: 'url' ['filename']"
    return 1
  fi
  url="$1"
  if [ $# -eq 1 ]
  then
    filename="$(basename "${url}")"
  else
    filename="$2"
  fi
  echo "Download: ${url}"
  # using '-L' for redirects i.e. when using SourceForge
  if ! curl -L --silent --output "${filename}" "${url}"
  then
    echo "error downloading: ${url}"
    rm -f "${filename}"
    return 1
  fi
  if [ ! -s "${filename}" ]
  then
    echo "downloaded empty file '${filename}'"
    rm -f "${filename}"
    return 1
  fi
  return 0
}

# Install memdisk
VERSION="5.10"
TARGET="${ISO_DIR}/memdisk"
echo "Checking: ${TARGET}"
if [ ! -f "${TARGET}" ]
then
  FILE="syslinux-${VERSION}.zip"
  if download "https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/${FILE}"
  then
    unzip -q "${FILE}" memdisk/memdisk
    mv memdisk/memdisk "${TARGET}"
    rmdir memdisk/
    rm "${FILE}"
  fi
fi

# Install Memtest86+
VERSION="6.20"
TARGET="${ISO_DIR}/mt86plus_${VERSION}_64.iso"
echo "Checking: ${TARGET}"
if [ ! -f "${TARGET}" ]
then
  FILE="mt86plus_${VERSION}_64.iso"
  if download "https://memtest.org/download/v${VERSION}/${FILE}.zip"
  then
    unzip -q "${FILE}.zip" "${FILE}"
    mv "${FILE}" "${TARGET}"
    rm "${FILE}.zip"
  fi
fi
TARGET="${ISO_DIR}/memtest64.efi"
echo "Checking: ${TARGET}"
if [ ! -f "${TARGET}" ]
then
  FILE="mt86plus_${VERSION}.binaries.zip"
  if download "https://memtest.org/download/v${VERSION}/${FILE}"
  then
    unzip -q "${FILE}" memtest64.efi
    mv memtest64.efi "${TARGET}"
    rm "${FILE}"
  fi
fi

# Install SystemRescue
VERSION="10.00"
TARGET="${ISO_DIR}/systemrescue/"
echo "Checking: ${TARGET}"
if [ ! -d "${TARGET}" ]
then
  FILE="systemrescue-${VERSION}-amd64.iso"
  if download "https://sourceforge.net/projects/systemrescuecd/files/sysresccd-x86/${VERSION}/${FILE}/download" "${FILE}"
  then
    7z -bso0 -bsp0 x "${FILE}" "-o${TARGET}"
    rm "${FILE}"
  fi
fi

# Install FreeDOS
VERSION="1.3"
TARGET="${ISO_DIR}/freedos_${VERSION}_live.iso"
echo "Checking: ${TARGET}"
if [ ! -f "${TARGET}" ]
then
  FILE="FD13-LiveCD.zip"
  if download "https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/${VERSION}/official/${FILE}"
  then
    unzip -q "${FILE}" FD13LIVE.iso
    mv FD13LIVE.iso "${TARGET}"
    rm "${FILE}"
  fi
fi


### Copy Ubuntu Subiquity files
if [ ! -d "${ROOT_DIR}/ubuntu" ]
then
  mkdir "${ROOT_DIR}/ubuntu"
fi
cp -r /content/ubuntu/*  "${ROOT_DIR}/ubuntu"


### Start HTTP server
/pxe-httpd.py
