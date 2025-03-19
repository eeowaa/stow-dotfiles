## Requires: glab

if which glab >/dev/null 2>&1
then if [ "$BASH_VERSION" ]
     then glab completion --shell bash >"$BASH_COMPLETION_USER_DIR/completions/glab"
     elif [ "$ZSH_VERSION" ]
     then glab completion --shell zsh >"$ZDOTDIR/site-functions/_glab"
     else echo >&2 'glab completion not available for current shell'
     fi
fi
