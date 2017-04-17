#!/bin/bash
. ./paths
cd $BASEPATH
set -e
emerge --config-root=$BASEPATH/cfg/ -va1 --buildpkgonly dev-lang/perl
