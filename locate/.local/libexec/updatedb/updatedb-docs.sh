#!/bin/sh
case `uname -s` in
CYGWIN_NT*)
    private=
    dbroot="--localpaths=$XDG_DOCUMENTS_DIR"
    findopts='--findoptions=( -type d -name .git -print0 -prune ) -o' ;;
*)  private='--require-visibility=no'
    dbroot="--database-root=$XDG_DOCUMENTS_DIR"
    findopts= ;;
esac

# plocate's updatedb only references updatedb.conf (no environment variables)
if /usr/bin/env updatedb --version | grep plocate >/dev/null
then pruning="--prunefs= --prunepaths='$PRUNEPATHS' --prunenames='$PRUNENAMES'"
else pruning='--prunefs='
fi

eval "\
/usr/bin/env updatedb $private $pruning ${findopts:+"$findopts"} $dbroot \
    --output='$XDG_CACHE_HOME/locate/locatedb.docs'"
