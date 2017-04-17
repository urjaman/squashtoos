#!/bin/sh
set -e
. ./paths
SZMB=768
cd $BASEPATH
mkdir -p $GENNAME-cc/boot
cp -va boot/* $GENNAME-cc/boot/
rm -rf iso
mkdir -p iso/boot/grub
cp ../isogrub.cfg iso/boot/grub/grub.cfg
grub-mkrescue -o bootimg.bin iso
rm -rf iso
M=M
truncate bootimg.bin -s $SZMB$M
printf 'n\np\n\n\n\nw\nq\n' | fdisk bootimg.bin
START=$(fdisk -l bootimg.bin | grep bootimg.bin2 | awk '{print $2}')
SIZE=$(fdisk -l bootimg.bin | grep bootimg.bin2 | awk '{print $4}')
BLOCKS=$(expr $SIZE '/' 2)
INODES=$(expr $SIZE '/' 128)
echo $START $SIZE $BLOCKS $INODES
# you might need genext2fs from their CVS
mke2img -b $BLOCKS -i $INODES -d $GENNAME-cc -o ext4.bin -G 4 # mke2img is from buildroot
dd if=bootimg.bin bs=512 count=$START of=pre_img.bin # take the part before the ext4 partition...
cat pre_img.bin ext4.bin > bootimg.bin # and make a new one with this ext4 fs...
rm pre_img.bin ext4.bin # and delete temp files...
