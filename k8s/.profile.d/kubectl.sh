## Requires: kubectl

if [ "$BASH_VERSION" ]
then kubectl completion bash >"$BASH_COMPLETION_USER_DIR/completions/kubectl"
elif [ "$ZSH_VERSION" ]
then kubectl completion zsh >"$ZDOTDIR/site-functions/_kubectl"
else echo >&2 'Kubectl completion not available for current shell'
fi
