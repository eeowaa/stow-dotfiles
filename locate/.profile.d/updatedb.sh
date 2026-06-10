FINDOPTIONS='-type d -name .git -prune -o -print'
PRUNEPATHS="\
/tmp \
/usr/tmp \
/var/tmp \
/var/spool \
/var/lock \
/var/run \
/run \
/media \
/mnt \
/proc \
/sys \
/dev"
PRUNENAMES='.git'
export FINDOPTIONS PRUNEPATHS PRUNENAMES
