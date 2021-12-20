## Requires: krew

PATH=${KREW_ROOT:-$HOME/.krew}/bin:$PATH
export PATH

if [ "$BASH_VERSION" ]
then kubectl krew completion bash >"$BASH_COMPLETION_COMPAT_DIR/completions/krew"
elif [ "$ZSH_VERSION" ]
then kubectl krew completion zsh >"$ZDOTDIR/site-functions/_krew"
else echo >&2 'Krew completion not available for current shell'
fi
