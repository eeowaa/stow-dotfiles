## Requires: fd-find fzf parallel
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
            # Enable word splitting in zsh
            local nosplit
            [ "$ZSH_VERSION" ] && [[ ! -o shwordsplit ]] && {
                setopt shwordsplit
                nosplit=X
            }

            # Split colon-delimited JUMP_PATH and assign to argument list
            local OLD_IFS=$IFS
            IFS=:
            set -- ${JUMP_PATH:-$HOME}
            IFS=$OLD_IFS

            # Interactively select a directory in JUMP_PATH
            JUMPDIR=$(
                parallel --line-buffer --quote \
                    fd -Htd -E '.git*' $JUMP_OPTIONS . '{}' \
                    ::: "$@" 2>/dev/null | fzf
            )

            # Restore setting for word splitting
            [ "$nosplit" ] && unsetopt shwordsplit
        }
        [ "X$JUMPDIR" = X ] && return 1
        JUMPLIST=$JUMPDIR${JUMPLIST:+:}$JUMPLIST
        ;;
    esac
    cd "$JUMPDIR"
    echo "$JUMPDIR"
}
