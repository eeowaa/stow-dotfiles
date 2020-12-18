# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html
if [ "$BASH_VERSION" ] || {
    [ "$ZSH_VERSION" ] && autoload bashcompinit && bashcompinit
}; then 
    complete -C aws_completer aws
else
    echo >&2 'AWS CLI completion not available for current shell'
fi
