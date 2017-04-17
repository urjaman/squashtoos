#!/bin/sh
set -e
./emerge.sh
./cc.sh
../squash.sh
