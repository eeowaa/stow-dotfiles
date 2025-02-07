# Automatically activate a Python virtualenv
activate() {
    # Check for virtual environment directories via environment variable,
    # direnv, pipenv, and implicit convention, in that order.  Ignores some
    # tooling like virtualenvwrapper and pyvenv.
    for venv in "$VIRTUAL_ENV" \
                .direnv/python-?* .direnv/virtualenv \
                "`pipenv --venv 2>/dev/null`" \
                .venv venv
    do
        if [ -d "$venv" ] && [ -f "$venv/bin/activate" ]
        then
            . "$venv/bin/activate"
            return $?
        fi
    done
    echo >&2 'Could not find virtualenv activation script'
    return 1
}

# FIXME
alias pyref='$BROWSER file:///usr/share/doc/python2/html/index.html'
