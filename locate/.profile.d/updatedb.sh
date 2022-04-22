FINDOPTIONS='-type d -name .git -prune -o -print'
PRUNEPATHS='/tmp /usr/tmp /var/tmp /var/spool /media /mnt /proc'
PRUNENAMES='.git'
export FINDOPTIONS PRUNEPATHS PRUNENAMES
