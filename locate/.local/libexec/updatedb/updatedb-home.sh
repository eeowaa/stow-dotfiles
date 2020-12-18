#!/bin/sh
case `uname -s` in
CYGWIN_NT*)
    cygdrive=`mount -p | awk 'NR == 2 { print $1 }'`
    winroot=`cygpath -m / | sed 's/^\(.\):/\1/' | tr A-Z a-z`
    cygdirs="$cygdrive/$winroot
$HOME/AppData/Local/Temp
$HOME/AppData/LocalLow/Temp
"   ;;
*)  cygdirs= ;;
esac

mkdir -p "$XDG_CACHE_HOME/locate"
/usr/bin/env updatedb --prunefs= \
    --findoptions='-false -o' \
    --localpaths="$HOME" \
    --prunepaths="$cygdirs\
$XDG_DOCUMENTS_DIR" \
    --output="$XDG_CACHE_HOME/locate/locatedb.home"
