#!/bin/bash

set -e

D=$(mktemp -d)
mkdir $D/lib

PKGS="$(prt-get depends \
	xorg-libxcomposite xorg-libxcursor xorg-libxi \
	xorg-libxt xorg-libxdamage xorg-libxinerama \
	| cut -b5- | grep "^xorg\-")"

prt-get grpinst $PKGS

for p in $PKGS ; do
	for l in $(pkginfo -l $p | grep "^usr/lib/.*\.so.*") ; do
		cp -a /$l $D/lib
	done
done

prt-get remove $PKGS

tar -C $D -J -cf $(basename $0 .sh).tar.xz lib
rm -rf $D
