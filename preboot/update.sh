#!/bin/sh
set -e
cd /
echo "Receiving xdelta3..."
xdelta3 -d -s usr.sqfs > usr_.sqfs
mv usr_.sqfs usr.sqfs
if [ -f /boot/vmlinuz.new ]; then
	mv /boot/vmlinuz.new /boot/vmlinuz
	echo "kernel update moved."
fi
echo "Remote done."
