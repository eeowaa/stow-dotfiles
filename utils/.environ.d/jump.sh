## Requires: fd-find fzf parallel
jump() {
    case $1 in
    -l)
        # List directories in $JUMP_LIST (like `dirs`).
        [ "X$JUMP_LIST" = X ] || echo "X$JUMP_LIST" | cut -c2- | tr : '\n'
        return 0
        ;;
    -)
        # Jump to the previous directory in $JUMP_LIST (like `popd`).
        "X$JUMP_LIST" = X ] && {
            echo >&2 'JUMP_LIST is empty'
            return 1
        }
        JUMP_DIR=${JUMP_LIST%%:*}
        JUMP_LIST=`echo "$JUMP_LIST" | sed "s/^[^:]*:\{0,1\}//"`
        ;;
    *)
        # Jump to an interactively-selected directory (like `pushd`).
        # Top-level directories can be specified with function arguments.
        # If no arguments are supplied, colon-separated directories in
        # $JUMP_PATH are the top-level directories, falling back to $HOME.
        [ $# -eq 0 ] &&
        {
            # Enable word-splitting in ZSH
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

            # Restore setting for word splitting
            [ "$nosplit" ] && unsetopt shwordsplit
        }

        # Interactively select a directory, adding it to $JUMP_LIST.
        JUMP_DIR=$(
            parallel --line-buffer --quote \
                fd -Htd -E '.git*' $JUMP_OPTIONS . '{}' \
                ::: "$@" 2>/dev/null | fzf
        )
        [ "X$JUMP_DIR" = X ] && return 1
        JUMP_LIST=$JUMP_DIR${JUMP_LIST:+:}$JUMP_LIST
        ;;
    esac

    # Jump to the directory
    cd "$JUMP_DIR"
    echo "$JUMP_DIR"
}
