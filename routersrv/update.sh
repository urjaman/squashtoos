#!/bin/bash
# update a remote system using xdelta of usr.sqfs
. ./paths
cd $BASEPATH
set -e
REMOTE=192.168.1.80
scp boot/vmlinuz $REMOTE:/boot/vmlinuz.new
echo "Sending xdelta3..."
xdelta3 -s prev.sqfs < $GENNAME-cc/usr.sqfs | ssh $REMOTE /update.sh
mv $GENNAME-cc/usr.sqfs prev.sqfs
echo "Done."
