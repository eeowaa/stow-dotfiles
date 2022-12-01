## Requires: tput
# tmux() {
#     if [ "`tput colors`" -lt 256 ]
#     then command tmux -f "$XDG_CONFIG_HOME/tmux/tmux.conf" ${1+"$@"}
#     else command tmux -f "$XDG_CONFIG_HOME/tmux/tmux.conf" -2 ${1+"$@"}
#     fi
# }
