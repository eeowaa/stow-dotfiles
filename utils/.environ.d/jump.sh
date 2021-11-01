## Requires: fd fzf
jump() {
    case $1 in
    -l) [ "X$JUMPLIST" = X ] || echo "X$JUMPLIST" | cut -c2- | tr : '\n'
        return 0
        ;;
    -)  [ "X$JUMPLIST" = X ] && {
            echo >&2 'JUMPLIST is empty'
            return 1
        }
        JUMPDIR=${JUMPLIST%%:*}
        JUMPLIST=`echo "$JUMPLIST" | sed "s/^[^:]*:\{0,1\}//"`
        ;;
    *)
        JUMPDIR=`eval "fd --hidden --type directory $JUMP_OPTIONS . '${@:-$HOME}'" | fzf`
        [ "X$JUMPDIR" = X ] && return 1
        JUMPLIST=$JUMPDIR${JUMPLIST:+:}$JUMPLIST
        ;;
    esac
    cd "$JUMPDIR"
    echo "$JUMPDIR"
}
