## Requires: fd fzf
alias _jumpdirs="\
fd --hidden --type directory --exclude '.git*' $JUMP_OPTIONS . 2>/dev/null"
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
        [ $# -eq 0 ] && {
            local toggle
            [ "$ZSH_VERSION" ] && [[ ! -o shwordsplit ]] && {
                setopt shwordsplit
                toggle=X
            }
            local OLD_IFS=$IFS
            IFS=:
            set -- ${JUMP_PATH:-$HOME}
            IFS=$OLD_IFS
            [ "$toggle" ] && unsetopt shwordsplit
        }
        JUMPDIR=`_jumpdirs "$@" | fzf`
        [ "X$JUMPDIR" = X ] && return 1
        JUMPLIST=$JUMPDIR${JUMPLIST:+:}$JUMPLIST
        ;;
    esac
    cd "$JUMPDIR"
    echo "$JUMPDIR"
}
