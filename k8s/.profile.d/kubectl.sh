## Requires: kubectl

if [ "$BASH_VERSION" ]
then [ -f /usr/share/bash-completion/completions/kubectl ] ||
        kubectl completion bash >"$BASH_COMPLETION_USER_DIR/completions/kubectl"
elif [ "$ZSH_VERSION" ]
then [ -f /usr/share/zsh/site-functions/_kubectl ] ||
        kubectl completion zsh >"$ZDOTDIR/site-functions/_kubectl"
else echo >&2 'Kubectl completion not available for current shell'
fi
