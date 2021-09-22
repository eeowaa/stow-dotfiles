# See documentation output from `pipx completion`
if [ "$BASH_VERSION" ] || {
    [ "$ZSH_VERSION" ] && autoload bashcompinit && bashcompinit
}; then
    eval "`register-python-argcomplete pipx`"
else
    echo >&2 'AWS CLI completion not available for current shell'
fi
