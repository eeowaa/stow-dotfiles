## Requires: pipx
#
# - See documentation output from `pipx completions`
# - The default argument for `register-python-argcomplete --shell` is `bash`
# - It appears that autocompletion is loaded from a file:
#
#   $ diff -s <(register-python-argcomplete pipx) /usr/share/bash-completion/completions/pipx.bash
#   Files /proc/self/fd/11 and /usr/share/bash-completion/completions/pipx.bash are identical
#
{ [ "$BASH_VERSION" ] || [ "$ZSH_VERSION" ]; } \
    && eval "`register-python-argcomplete pipx`" \
    || echo >&2 'pipx completion not available for current shell'
