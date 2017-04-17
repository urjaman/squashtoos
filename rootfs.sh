#!/bin/bash
. ./paths
cd $BASEPATH
rm -rf $GENNAME
mkdir $GENNAME
mkdir $GENNAME/dev
mkdir $GENNAME/proc
mkdir $GENNAME/sys
mkdir $GENNAME/boot
mkdir $GENNAME/home
mkdir $GENNAME/root
mkdir $GENNAME/run
mkdir -p $GENNAME/usr/include
set -e
./emerge.sh
