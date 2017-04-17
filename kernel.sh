#!/bin/bash
. ./paths
cd $BASEPATH
rm -f boot/vmlinuz
if [ ! -d "kernel" ]; then
	echo "Copying kernel tree..."
	cp -a /usr/src/linux-4.9.16-gentoo kernel
fi
set -e
cd kernel
make -j8 mrproper
cp ../kernel-cfg .config || true
make menuconfig
#make oldconfig
make -j8 bzImage modules
cd ..
mkdir -p boot
cp kernel/arch/x86/boot/bzImage boot/vmlinuz
cp kernel/.config kernel-cfg

