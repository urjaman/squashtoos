#!/bin/sh
set -e
. ./paths
cd $BASEPATH/$GENNAME-cc
mv etc usr/.etc
mksquashfs usr usr.sqfs
rm -rf usr
mkdir usr .usr-ro .usr-rw .usr-wrk etc etc-rw .etc-wrk
