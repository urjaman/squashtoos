#!/bin/sh
set -e
../rootfs.sh
../krefresh.sh
./cc.sh
../squash.sh
#../mkbootimg.sh
#../mkbootdat.sh
