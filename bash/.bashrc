if [ "$DEBUG" ]; then
    echo "Sourcing: $BASH_SOURCE" >&2
fi

if [[ ! -v __ENVIRON_SOURCED ]]; then
    # Set the command prompt
    # https://www.howtogeek.com/307701/how-to-customize-and-colorize-your-bash-prompt/
    function my_ps1
    {
        # This could be much more readable, but this function must be optimized
        # in order to avoid delay on slower platforms (read: Cygwin)
        if [ $? -eq 0 ]
        then export PS1='\[\033[1;35m\][\j] \[\033[2;37m\]\w \[\033[00m\]\$ '"$PS1_EXTRA"
        else export PS1='\[\033[1;35m\][\j] \[\033[2;37m\]\w \[\033[1;31m\]\$\[\033[00m\] '"$PS1_EXTRA"
        fi
    }
    export -f my_ps1
    unset PROMPT_COMMAND  # XXX: PROMPT_COMMAND must be a string, not an array, for direnv to work
    export PROMPT_COMMAND=my_ps1
    export PROMPT_DIRTRIM=2

    # Source generic Bourne Shell environment (also sets __ENVIRON_SOURCED)
    [[ -f "$ENV" ]] && source "$ENV"
else
    # Shell and terminal settings copied from "$ENV"
    set +o vi
    set -o emacs
    stty -ixon
fi

# Clear the screen while preserving scrollback in Emacs terminal emulators
# (eterm_clear is defined in ~/.environ.d/emacs.sh)
case $INSIDE_EMACS in *term*)
    bind -x '"\C-l": eterm_clear' ;;
esac

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
