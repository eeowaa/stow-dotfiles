_alias ec emacsclient

woman() {
    emacsclient -ne "(woman \"$1\")"
}; _exportf woman

case $INSIDE_EMACS in *term*)
    # In Emacs terminal emulators (e.g., term, ansi-term, vterm, eat),
    # Ctrl-L discards the visible screen instead of preserving it
    # in scrollback. Scroll the screen into history first, then
    # clear it. The sleep is required because the terminal emulator
    # processes the scrolling asynchronously.
    eterm_clear() {
        printf '\n%.0s' $(seq $((LINES - 1))) # assumes 1-line prompt
        sleep 0.05 # works most of the time (0.1 seconds always works)
        printf '\e[H\e[2J'
        if [ "$ZSH_VERSION" ]; then zle redisplay; fi
    }; _exportf eterm_clear ;;
esac
