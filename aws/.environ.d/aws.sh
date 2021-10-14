# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html
if [ "$BASH_VERSION" ] || {
    [ "$ZSH_VERSION" ] && autoload bashcompinit && bashcompinit
}; then 
    complete -C aws_completer aws
else
    echo >&2 'AWS CLI completion not available for current shell'
fi

# Thin wrapper for aws command
aws() {
    case $1 in
    login)
        shift
        aws_login ${1+"$@"} ;;
    *)
        command aws ${1+"$@"} ;;
    esac
}

# Wrapper for `aws sso login`
aws_login() {
    # Interactively obtain a profile if one wasn't supplied
    if [ $# -eq 0 ]
    then profile=`command aws configure list-profiles | fzf`
    else profile=$*
    fi
    [ "X$profile" = X ] && return 1

    # Use the system web browser to supply credentials
    BROWSER= aws sso login --profile "$profile" && {
        # Let the user see what is going on
        set -x

        # Bypass the need for the --profile flag upon subsequent AWS CLI invocations
        export AWS_PROFILE=$profile

        # Print debugging information
        command aws sts get-caller-identity

        { set +x; } 2>/dev/null
    }
}
