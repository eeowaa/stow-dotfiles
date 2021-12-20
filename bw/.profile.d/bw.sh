if [ "$ZSH_VERSION" ]
then bw completion --shell zsh >"$ZDOTDIR/site-functions/_bw"
else echo >&2 'Bitwarden CLI completion not available for current shell'
fi
