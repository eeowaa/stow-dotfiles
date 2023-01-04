# The `bw` command may appear ahead of ~/.local/bin in $PATH, so I can't
# reliably create a wrapper script. A shell function will do.
bw() { (
    set +x
    [ -d "$XDG_CACHE_HOME" ] || XDG_CACHE_HOME=$HOME/.cache
    cache=$XDG_CACHE_HOME/bw/session
    if [ -r "$cache" ]; then
        BW_SESSION=`cat "$cache"`
        export BW_SESSION
    fi
    case $1 in
    login)
        [ -f "$cache" ] || touch "$cache"
        chmod 600 "$cache"
        command bw ${1+"$@"} | awk '
        match($0, /--session [a-zA-Z0-9+/=]{88}/) {
            key = substr($0, RSTART + 10, 88)
            print key > CACHE
        } {
            print
        } END {
            print "\n*** session key has been saved to", CACHE
        }' CACHE="$cache" ;;
    *)
        command bw ${1+"$@"} ;;
    esac
); }
