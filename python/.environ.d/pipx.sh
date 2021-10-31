## Requires: pipx
# See documentation output from `pipx completion`
{
    [ "$BASH_VERSION" ] || {
        [ "$ZSH_VERSION" ] && autoload bashcompinit && bashcompinit
    }
} && eval "`register-python-argcomplete pipx`" \
  || echo >&2 'pipx completion not available for current shell'
