#!/bin/sh
mkdir -p "$XDG_CACHE_HOME/locate"
/usr/bin/env updatedb --prunefs= \
    --findoptions='( -type d -name .git -print0 -prune ) -o' \
    --localpaths="$XDG_DOCUMENTS_DIR" \
    --output="$XDG_CACHE_HOME/locate/locatedb.docs"
