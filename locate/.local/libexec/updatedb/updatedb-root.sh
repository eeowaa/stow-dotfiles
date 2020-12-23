#!/bin/sh
case `uname -s` in
CYGWIN_NT*)
    cygdrive=`mount -p | awk 'NR == 2 { print $1 }'` ;;
*)  cygdrive= ;;
esac

/usr/bin/env updatedb --prunefs= \
    --prunepaths="$cygdrive /tmp /usr/tmp /var/tmp /var/lock /var/run /run /media /mnt /proc" \
    --findoptions='( -type d -name .git -print0 -prune ) -o' \
    --output="$XDG_CACHE_HOME/locate/locatedb.root"
