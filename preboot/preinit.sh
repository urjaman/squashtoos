#!/busybox sh
mount -t proc proc proc
mount -o loop,ro -t squashfs usr.sqfs .usr-ro
mount -o remount,rw /
mount -olowerdir=/.usr-ro,upperdir=/.usr-rw,workdir=/.usr-wrk -t overlay overlay usr
mount -olowerdir=/.usr-ro/.etc,upperdir=/etc-rw,workdir=/.etc-wrk -t overlay overlay etc
cat /var/lib/misc/random-seed > /dev/urandom
if [ -e /sbin/init ]; then
	exec /sbin/init "$@"
fi
exec sh
