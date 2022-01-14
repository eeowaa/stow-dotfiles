# Along with enabling bash-completion compatibility for zsh (which we have
# already done in .zshrc), /usr/share/bash-completion/completions/azure-cli
# just runs the following eval command:
{ [ "$BASH_VERSION" ] || [ "$ZSH_VERSION" ]; } \
    && eval "`register-python-argcomplete az`" \
    || echo >&2 'az completion not available for current shell'
