## Requires: ecctl

if [ "$BASH_VERSION" ]
then ecctl generate completions -l "$BASH_COMPLETION_USER_DIR/completions/ecctl"
elif [ "$ZSH_VERSION" ]
then ecctl generate completions -l "$ZDOTDIR/site-functions/_ecctl"
else echo >&2 'ecctl completion not available for current shell'
fi
