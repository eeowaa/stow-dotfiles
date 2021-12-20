## Requires: mongocli
if [ "$BASH_VERSION" ]
then mongocli completion bash >"$BASH_COMPLETION_COMPAT_DIR/completions/mongocli"
elif [ "$ZSH_VERSION" ]
then mongocli completion zsh >"$ZDOTDIR/site-functions/_mongocli"
else echo >&2 'Mongo CLI completion not available for current shell'
fi
