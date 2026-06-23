_alias ec emacsclient

woman() {
    emacsclient -ne "(woman \"$1\")"
}; _exportf woman

case $INSIDE_EMACS in *term*)
    eterm_clear() {
        printf '\n%.0s' $(seq $((LINES - 1)))
        printf '\e[H\e[2J'
        if [ "$ZSH_VERSION" ]; then zle redisplay; fi
    }; _exportf eterm_clear ;;
esac
