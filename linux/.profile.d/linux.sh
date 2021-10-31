## Requires: tput
# Root directory for custom terminfo entries
TERMINFO=$XDG_CONFIG_HOME/terminfo
export TERMINFO

# Reset cursor to normal (according to $TERMINFO/l/linux) upon login
tput cnorm
