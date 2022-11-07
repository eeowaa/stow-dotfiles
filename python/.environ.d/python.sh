# Automatically activate a Python virtualenv
activate() {
    for venv in "$VIRTUAL_ENV" "`pipenv --venv 2>/dev/null`" .venv venv
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
