## Requires: kompose

if [ "$BASH_VERSION" ]
then kompose completion bash >"$BASH_COMPLETION_USER_DIR/completions/kompose"
elif [ "$ZSH_VERSION" ]
then kompose completion zsh >"$ZDOTDIR/site-functions/_kompose"
else echo >&2 'Kompose completion not available for current shell'
fi
