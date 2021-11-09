if [ "$DEBUG" ]; then
    echo >&2 "Sourcing: ${(%):-%N}"

    # Prevent subprocesses in Emacs (including clipboard integration)
    # from outputing shell debugging information
    for e in emacs emacsclient; do
        eval "\
        function $e {
            unset DEBUG
            unfunction $e
            $e "\$@"
        }"
    done
fi

export ZDOTDIR=$HOME/.config/zsh
