# Reference:
# - <https://community.bitwarden.com/t/best-practices-log-out-or-lock/51207>
# - <https://bitwarden.com/help/cli/>

if [ "$ZSH_VERSION" ]
then bw completion --shell zsh >"$ZDOTDIR/site-functions/_bw"
else echo >&2 'Bitwarden CLI completion not available for current shell'
fi

# Search BitWarden for passwords using the `getpw` utility script
case $GETPW_BACKENDS in *bitwarden*) ;; *)
    GETPW_BACKENDS=${GETPW_BACKENDS:+"$GETPW_BACKENDS "}bitwarden
    export GETPW_BACKENDS ;;
esac

# Configure the `bw` wrapper script
BW_SESSION_CACHE=$XDG_CACHE_HOME/bw/session
export BW_SESSION_CACHE
