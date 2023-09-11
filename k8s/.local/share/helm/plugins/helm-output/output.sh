#!/bin/sh -e
## Requires: ed

# Render chart templates to "$HELM_CACHE_DIR/output"
eval "`helm env`"
outdir=`realpath "$HELM_CACHE_HOME/output"`
$HELM_BIN template --output-dir "$outdir" ${1+"$@"}

# Change "<repo>/<path>" to "<chartdir>/<path>" in comments
chartdir=`pwd | sed 's,/,\\\\/,g'`
find "$outdir" -type f | while read f
do
    ed "$f" >/dev/null <<EOF
g/^# Source: [^\\/]*/s//# Source: $chartdir/
w
q
EOF
done

# TODO: Preserve the order of templates in each file
