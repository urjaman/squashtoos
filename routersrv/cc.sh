#!/bin/bash
# config and cleanup
. ./paths
cd $BASEPATH
rm -rf $GENNAME-cc
cp -a $GENNAME $GENNAME-cc

copy_ug ()
{
	grep $1 /etc/passwd >> $GENNAME-cc/etc/passwd
	grep $1 /etc/group >> $GENNAME-cc/etc/group
	grep $1 /etc/shadow >> $GENNAME-cc/etc/shadow
}

#install important gcc-provided libs (we dont want to install all of gcc, so thats why this)
#cp -aLv /usr/lib/gcc/*pc*/*/lib{gcc_s,stdc++}.so.? $GENNAME-cc/usr/lib

# null out the password so it's possible to login locally without mage-like information :P
# Please set a password if you're going to run it for more than 5min :P (or enable ssh or something)
passwd -R $BASEPATH/$GENNAME-cc -d root
echo hostname="$GENNAME" > $GENNAME-cc/etc/conf.d/hostname
chroot $GENNAME-cc rc-update del keymaps boot
chroot $GENNAME-cc rc-update del fsck boot
chroot $GENNAME-cc rc-update del swapfiles boot
chroot $GENNAME-cc rc-update add sysklogd default
chroot $GENNAME-cc rc-update add cronie default

# serial shell...
echo "s0:12345:respawn:/sbin/agetty -L 115200 ttyS0 vt100" >> $GENNAME-cc/etc/inittab

# ssh config
chroot $GENNAME-cc rc-update add sshd default
echo "ChallengeResponseAuthentication no" >> $GENNAME-cc/etc/ssh/sshd_config
# put in some authorized keys the builder has :P
mkdir -p $GENNAME-cc/root/.ssh
chmod 700 $GENNAME-cc/root/.ssh
cp -va ~/.ssh/authorized_keys $GENNAME-cc/root/.ssh
# add sshd user from host system
copy_ug sshd

# add lighttpd user from host system
copy_ug lighttpd

# add tinyproxy user from host system (tinyproxy is left off by default so you can config it)
copy_ug tinyproxy
copy_ug squid

# ldap...
copy_ug ldap

copy_ug cron
grep crontab /etc/group >> $GENNAME-cc/etc/group
grep input /etc/group >> $GENNAME-cc/etc/group

copy_ug messagebus
copy_ug ddclient

# mail
copy_ug mail
copy_ug postmaster
copy_ug dovecot
copy_ug dovenull
copy_ug postfix
grep postdrop /etc/group >> $GENNAME-cc/etc/group


# create the basic user
NORMALNAME=urjaman
chroot $GENNAME-cc useradd -g users -G wheel -m $NORMALNAME
#and wipe the pw as with root too...
passwd -R $BASEPATH/$GENNAME-cc -d $NORMALNAME

#some system config (dummy fstab, timezone, locale, one and only env-update..)
echo > $GENNAME-cc/etc/fstab
echo "tmpfs / tmpfs defaults 0 0" >> $GENNAME-cc/etc/fstab
echo >> $GENNAME-cc/etc/fstab
MTZ=Europe/Helsinki
echo "$MTZ" > $GENNAME-cc/etc/timezone
cp -f $GENNAME-cc/usr/share/zoneinfo/$MTZ $GENNAME-cc/etc/localtime
echo "en_US.UTF-8 UTF-8" > $GENNAME-cc/etc/locale.gen
echo 'LANG="en_US.utf8"' > $GENNAME-cc/etc/env.d/02locale
touch $GENNAME-cc/usr/share/locale/locale.alias
locale-gen --config $GENNAME-cc/etc/locale.gen --destdir $BASEPATH/$GENNAME-cc/
ROOT=$BASEPATH/$GENNAME-cc env-update



# cleanup dev things
rm -rf $GENNAME-cc/var/db/pkg
rm -rf $GENNAME-cc/usr/share/gtk-doc
rm -rf $GENNAME-cc/var/cache/edb
rm -rf $GENNAME-cc/var/lib/gentoo

#perform /usr-ization
cd $GENNAME-cc
mv lib/* usr/lib/
mv sbin/* usr/sbin/
mv bin/* usr/bin/
rm -rf lib sbin bin
ln -s usr/lib lib
ln -s usr/bin bin
ln -s usr/sbin sbin
#fix a broken awk symlink..
cd usr/bin
rm -v awk
ln -vs gawk awk
#provide a dummy st -> xterm symlink for surf downloads
ln -vs xterm st
cd $BASEPATH
cp -aLv ../preboot/* $GENNAME-cc
