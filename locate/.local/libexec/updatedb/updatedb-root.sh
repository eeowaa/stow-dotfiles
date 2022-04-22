#!/bin/sh
case `uname -s` in
CYGWIN_NT*)
    private=
    findopts='--findoptions=( -type d -name .git -print0 -prune ) -o'
    cygdrive=`mount -p | awk 'NR == 2 { print $1 }' | sed 's/[ 	]/\\&/g'` ;;
*)  private='--require-visibility=no'
    findopts=
    cygdrive=`echo "$HOME" | sed 's/[ 	]/\\&/g'` ;;
esac

/usr/bin/env updatedb $private --prunefs= \
    --prunepaths="$cygdrive /tmp /usr/tmp /var/tmp /var/lock /var/run /run /media /mnt /proc" \
    ${findopts:+"$findopts"} --output="$XDG_CACHE_HOME/locate/locatedb.root"
