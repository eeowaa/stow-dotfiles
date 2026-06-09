if [ "$DEBUG" ]; then
    echo "Sourcing: $BASH_SOURCE" >&2
fi

# Source generic Bourne Shell environment
if [[ ! -v __ENVIRON_SOURCED && -f "$ENV" ]]; then
    source "$ENV"
else
    # Shell and terminal settings copied from "$ENV"
    set +o vi
    set -o emacs
    stty -ixon
fi

# Source bash completion
#
# NOTE: This is an expensive and slow operation, so it would be better to do in
# ~/.bash_profile if possible. However, completion is implemented via shell
# functions, and we don't know all of those function names ahead of time,
# so we don't know which functions to export (via `export -f') to subshells.
# There are almost certainly some decent workarounds using `compgen' or other
# inspection tools, but I'm not going to worry about this for now.
#
# NOTE: These are the paths to look at:
#   /etc/profile.d/bash_completion.sh
#     . /usr/share/bash-completion/bash_completion
#         . ${BASH_COMPLETION_COMPAT_DIR:-/etc/bash_completion.d}/*
#   /usr/share/bash-completion/completions/{kompose}
#   ~/.local/share/bash-completion/completions/
#   ~/.profile.d/
#
for prefix in /usr/local ''
do
    completion=$prefix/etc/profile.d/bash_completion.sh
    if [[ -f "$completion" ]]; then
        if [ "$DEBUG" ]; then
            echo "Sourcing: $completion" >&2
        fi
        source "$completion"
        break
    fi
done
unset completion
