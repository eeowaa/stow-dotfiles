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
    account-name)
        shift
        aws_account_name ${1+"$@"} ;;
    *)
        command aws ${1+"$@"} ;;
    esac
}

# Wrapper for `aws sso login`
aws_login() {
    # Interactively obtain a profile if one wasn't supplied
    if [ $# -eq 0 ]
    then local profile=`command aws configure list-profiles | fzf`
    else local profile=$*
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

aws_account_name() {
    [ $# -eq 1 ] || {
        echo >&2 'Usage: aws account-name ACCOUNT_ID'
        return 1
    }
    local account_id=$1 config_file=$AWS_CONFIG_FILE
    [ -f "$config_file" ] || config_file=$HOME/.aws/config

    # XXX Assumptions:
    # 1. `sso_account_id` is always used to store account IDs
    # 2. The format is always `sso_account_id = <ID>`, spaces included
    # 3. The profile format is always `[profile <account-name>-<role>]`
    tac "$config_file" | awk '
        $1 == "sso_account_id" && $3 == ID { x = 1 }
        x && /\[profile / { print $2; exit }
    ' ID="$account_id" | sed 's/\(.*\)-.*/\1/'
}
