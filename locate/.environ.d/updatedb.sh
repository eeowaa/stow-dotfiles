## Requires: grep
updatedb() {
    { . "$HOME/.local/libexec/updatedb/updatedb-docs.sh" &
      . "$HOME/.local/libexec/updatedb/updatedb-home.sh" &
      . "$HOME/.local/libexec/updatedb/updatedb-root.sh" &
    } 2>&1 | grep --color=auto -iv 'permission denied'
    wait
}
