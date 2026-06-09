_alias ec emacsclient

woman() {
    emacsclient -ne "(woman \"$1\")"
}; _exportf woman
