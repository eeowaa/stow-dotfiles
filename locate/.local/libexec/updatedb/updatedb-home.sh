#!/bin/sh
case `uname -s` in
CYGWIN_NT*)
    private=
    dbroot="--localpaths=$HOME"
    findopts='--findoptions=-false -o'
    cygdrive=`mount -p | awk 'NR == 2 { print $1 }'`
    winroot=`cygpath -m / | sed 's/^\(.\):/\1/' | tr A-Z a-z`
    cygdirs="$cygdrive/$winroot
$HOME/AppData/Local/Temp
$HOME/AppData/LocalLow/Temp
"   ;;
*)  private='--require-visibility=no'
    dbroot="--database-root=$HOME"
    findopts=
    cygdirs= ;;
esac

/usr/bin/env updatedb $private --prunefs= ${findopts:+"$findopts"} "$dbroot" \
    --prunepaths="$cygdirs\
$XDG_DOCUMENTS_DIR" --output="$XDG_CACHE_HOME/locate/locatedb.home"
