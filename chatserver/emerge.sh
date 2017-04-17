#!/bin/bash
. ./paths
cd $BASEPATH
set -e
FANCY="squid app-crypt/certbot samba wine tigervnc fluxbox xterm sys-devel/gcc sys-devel/binutils make dev-vcs/git sys-devel/gdb"
FANCY2="autoconf automake bison flex binwalk mosh quota strace vim zip kicad www-client/surf mesa-progs spacefm unzip liberation-fonts terminus-font"
XFCE=">=x11-themes/gtk-engines-xfce-3:0 gtk-engines-xfce:3 hicolor-icon-theme xfce4-panel xfce4-session xfce4-settings xfdesktop xfwm4 dejavu xfce4-notifyd"
XFCE2="mousepad tango-icon-theme xfce4-terminal xfwm4-themes elementary-xfce-icon-theme"
EXTRATHINGS="net-fs/sshfs nano weechat app-misc/screen lighttpd xz-utils rsync elinks tinyproxy ddclient cronie logrotate app-misc/mc xdelta"
MAIL="dovecot postfix mutt"
LIBSIES="libusb-compat libusb pciutils linux-headers hwids e2fsprogs iptables >=dev-python/cryptography-1.5.2 sysklogd denyhosts"

emerge --tree --unordered-display --config-root=$BASEPATH/cfg/ --root=$BASEPATH/$GENNAME/ -vauDNk @system dhcpcd $EXTRATHINGS $LIBSIES $FANCY $FANCY2 $XFCE $XFCE2 $MAIL

