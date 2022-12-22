# The `bw` command may appear ahead of ~/.local/bin in $PATH, so I can't
# reliably create a wrapper script. A shell function will do.
bw() { (
    set +x
    [ -d "$XDG_CACHE_HOME" ] || XDG_CACHE_HOME=$HOME/.cache
    if [ -r "$XDG_CACHE_HOME/bw/session" ]; then
        BW_SESSION=`cat "$XDG_CACHE_HOME/bw/session"`
        export BW_SESSION
    fi
    command bw ${1+"$@"}
); }
