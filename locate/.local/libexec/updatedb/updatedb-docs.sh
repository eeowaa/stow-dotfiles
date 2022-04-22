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

eval "\
/usr/bin/env updatedb $private --prunefs= ${findopts:+"$findopts"} $dbroot \
    --output='$XDG_CACHE_HOME/locate/locatedb.docs'"
