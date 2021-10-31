## Requires: awscli expect perl wget unzip fzf jq coreutils
# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html
if [ "$BASH_VERSION" ] || {
    [ "$ZSH_VERSION" ] && autoload bashcompinit && bashcompinit
}; then 
    complete -C aws_completer aws
else
    echo >&2 'AWS CLI completion not available for current shell'
fi

# Wrapper for `aws` with additional subcommands and per-profile logging
aws() {
    local subcommand=$1
    case $subcommand in
    prompt|whoami|hostname|log|download-lambda|login|creds|account-name)
        shift
        eval aws_`echo $subcommand | tr - _` ${1+"$@"} ;;
    *)
        # Determine where to log the command
        local logfile=$XDG_CACHE_HOME/aws/log/${AWS_PROFILE:-'default'}.log

        # Log the current time
        date +'# %D %T' >>"$logfile"

        # Determine if we have autoprompting enabled for this command
        local autoprompt
        if env | grep -iq 'aws_cli_auto_prompt=on'
        then
            autoprompt=on
        else
            for arg
            do  [ "X$arg" = 'X--cli-auto-prompt' ] && {
                    autoprompt=on
                    break
                }
            done
        fi

        # No autoprompting
        if [ "X$autoprompt" = X ]
        then
            # Log the command line with shell-quoted arguments
            {
                set -x
                : QUOTED_ARGS ${1+"$@"}
                set +x
            } 2>&1 | sed -n -e 's/.*: QUOTED_ARGS /> aws /p' >>"$logfile"

            # Run the command and log its output
            command aws ${1+"$@"} | tee -a "$logfile"

            # Append an extra newline
            echo >>"$logfile"

        # Autoprompting enabled
        else
            # We need to use `expect` because autoprompting requires STDOUT to be
            # connected to a terminal in order to provide a good user experience,
            # which is kind of the whole point of the autoprompting interface
            local tmpfile=`mktemp`
            expect -c "
# Open a temporary file for writing
set log [open \"$tmpfile\" w]

# Run our command, hoping for the best with shell quoting
spawn command aws --no-cli-pager $*

# Wait for two consecutive carriage returns from the user
interact \"\r\r\" return

# Then send those carriage returns to the program
send \"\r\"
send \"\r\"

# Wait for the command prompt and then capture it
expect -re \"(> aws .*)\n\" {
    append output \$expect_out(0,string)
}

# Capture all of the command output
expect {
    \"\n\" {
        append output \$expect_out(buffer)
        exp_continue
    }
    eof {
        append output \$expect_out(buffer)
    }
}

# Write to our temporary file
puts \$log \$output" 

            # Remove control codes from the output and append to the log
            # Magic courtesy of <https://unix.stackexchange.com/a/18979>
            perl -pe '
s/ \e[ #%()*+\-.\/]. |
    \r | # Remove extra carriage returns also
    (?:\e\[|\x9b) [ -?]* [@-~] | # CSI ... Cmd
    (?:\e\]|\x9d) .*? (?:\e\\|[\a\x9c]) | # OSC ... (ST|BEL)
    (?:\e[P^_]|[\x90\x9e\x9f]) .*? (?:\e\\|\x9c) | # (DCS|PM|APC) ... ST
    \e.|[\x80-\x9f] //xg;
1 while s/[^\b][\b]//g;  # remove all non-backspace followed by backspace
' "$tmpfile" >>"$logfile"

            # Remove our temporary file
            rm "$tmpfile"
        fi ;;
    esac
}

alias aws_prompt='aws --cli-auto-prompt'
alias aws_whoami='aws sts get-caller-identity'

# For some reason, `aws iam list-account-aliases` doesn't work (should it?)
alias aws_hostname='aws account-name `aws whoami --query Account --output text`'

aws_log() {
    local logfile=$XDG_CACHE_HOME/aws/log/${AWS_PROFILE:-'default'}.log
    [ -f "$logfile" ] || {
        echo >&2 "File not found: $logfile"
        return 1
    }
    case $1 in
    -h|--help)
        cat >&2 <<EOF
Usage: aws log [-h | --help] [-p | --path] [rm] [OPTION]...
Options:
  -h, --help    Display this help text and exit.
  -p, --path    Show the path to the profile-specific log file and exit.
  [OPTION]...   Options to pass to the \`tail' command.

Use \`aws log rm' to remove the profile-specific log file, if it exists.
If no OPTION is given, \`cat' is used instead of \`tail' to display the log.
EOF
        return 1 ;;
    -p|--path)
        echo "$logfile" ;;
    rm)
        rm -f "$logfile" ;;
    '')
        cat "$logfile" ;;
    *)
        tail "$@" "$logfile" ;;
    esac
}

aws_download_lambda() {
    # Interactively select a lambda function if one wasn't supplied
    if [ $# -eq 0 ]
    then local lambda=`
         command aws lambda list-functions \
             --query 'Functions[].FunctionName' \
             --output text | tr '\t' '\n' | fzf`
    else local lambda=$*
    fi
    [ "X$lambda" = X ] && return 1
    local url=`
        aws lambda get-function \
            --function-name "$lambda" \
            --query Code.Location \
            --output text`
    wget -O "$lambda".zip "$url"
    unzip -d "$lambda" "$lambda".zip
    rm "$lambda".zip
    echo "Downloaded to directory: $lambda"
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
    BROWSER= AWS_PROFILE="$profile" aws sso login && {

        # Bypass the need for the --profile flag upon subsequent AWS CLI invocations
        echo "+ export AWS_PROFILE=$profile"
        export AWS_PROFILE=$profile

        # Print debugging information
        echo "+ aws sts get-caller-identity"
        aws sts get-caller-identity
    }
}

# Output credentials for an SSO session into environment variables
aws_creds() {
    local format=shell
    case $1 in
    -h|--help)
        cat >&2 <<EOF
Usage: aws creds [OPTION]...
Options:
  -h, --help    Display this help text and exit
  -s, --shell   Convert SSO creds to Bourne-compatible \`export' statement (default)
  -e, --emacs   Convert SSO creds to Emacs \`(progn (setenv ...) ...)' statement
EOF
        return 0 ;;
    -s|--shell) format=shell ;;
    -e|--emacs) format=emacs ;;
    esac
    # Will equal "<not" when there are no credentials
    local access_key_last4=`
        command aws configure list |
        awk '$1 == "access_key" { print substr($2, length($2) - 3) }'
    `
    [ "X$access_key_last4" = 'X<not' ] && return 1
    local cache_file=`grep -l \
        '"ProviderType": "sso".*"AccessKeyId": "[^"]*'"$access_key_last4\"" \
        "$HOME"/.aws/cli/cache/*
    `
    [ `echo "$cache_file" | wc -l` -eq 1 ] || {
        echo >&2 'Internal error: could not determine cache file'
        return 1
    }
    set -- `
        jq -r '.Credentials | .AccessKeyId, .SecretAccessKey,.SessionToken' \
            "$cache_file"
    `
    case $format in
    shell)
        cat <<EOF ;;
export AWS_ACCESS_KEY_ID='$1'
export AWS_SECRET_ACCESS_KEY='$2'
export AWS_SESSION_TOKEN='$3'
EOF
    emacs)
        cat <<EOF ;;
(progn
  (setenv "AWS_ACCESS_KEY_ID" "$1")
  (setenv "AWS_SECRET_ACCESS_KEY" "$2")
  (setenv "AWS_SESSION_TOKEN" "$3"))
EOF
    esac
}

# Translate an exact account ID into its name (as stored in the global AWS
# config file). This command relies on the following assumptions and conventions:
#
# 1. `sso_account_id` is always used to store account IDs
# 2. The format is always `sso_account_id = <ID>`, spaces included
# 3. The profile format is always `[profile <account-name>-<role>]`
#
aws_account_name() {
    [ $# -eq 1 ] || {
        echo >&2 'Usage: aws account-name ACCOUNT_ID'
        return 1
    }
    local account_id=$1 config_file=$AWS_CONFIG_FILE
    [ -f "$config_file" ] || config_file=$HOME/.aws/config

    tac "$config_file" | awk '
        $1 == "sso_account_id" && $3 == ID { x = 1 }
        x && /\[profile / { print $2; exit }
    ' ID="$account_id" | sed 's/\(.*\)-.*/\1/'
}
