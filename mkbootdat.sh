#!/bin/sh
set -e
. ./paths
cd $BASEPATH
mkdir -p $GENNAME-cc/boot
cp -va boot/* $GENNAME-cc/boot/
rm -rf iso
mkdir -p iso/boot/grub
cp ../isogrub.cfg iso/boot/grub/grub.cfg
grub-mkrescue -o bootimg.bin iso
rm -rf iso
gzip bootimg.bin
cd $GENNAME-cc
# CHECK: This was * but is now .
tar -czf ../rootfs.tar.gz .
