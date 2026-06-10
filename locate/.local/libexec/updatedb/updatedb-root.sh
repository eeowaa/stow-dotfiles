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

pruning="--prunefs= --prunepaths='$cygdrive $PRUNEPATHS'"

# plocate's updatedb only references updatedb.conf (no environment variables)
if /usr/bin/env updatedb --version | grep plocate >/dev/null
then pruning="$pruning --prunenames='$PRUNENAMES'"
fi

eval "\
/usr/bin/env updatedb $private $pruning ${findopts:+"$findopts"} \
    --output='$XDG_CACHE_HOME/locate/locatedb.root'"
