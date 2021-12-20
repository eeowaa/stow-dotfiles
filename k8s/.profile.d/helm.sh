## Requires: helm

if [ "$BASH_VERSION" ]
then helm completion bash >"$BASH_COMPLETION_COMPAT_DIR/completions/helm"
elif [ "$ZSH_VERSION" ]
then helm completion zsh >"$ZDOTDIR/site-functions/_helm"
else echo >&2 'Helm completion not available for current shell'
fi
