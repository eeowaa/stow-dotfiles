## Print a string from STDIN and read a value from the TTY device
## Requires: tput

# Usage: prompt [VARIABLE [VALUE]...]
#
# Notes:
#   1. If no arguments are given, TTY input is discarded
#   2. If VARIABLE is provided, TTY input is read into VARIABLE
#   3. If one or more VALUEs are given, TTY input must match one of them
#   4. Whitespace is trimmed from the beginning and end of TTY input
#   5. TTY input is case-sensitive
#   6. Invalid input generates an alarm tone, but no error message
#
# Examples:
#
#   $ prompt name <<EOF
#   Hi, I'm Alice!
#   What's your name?
#   EOF
#   Hi, I'm Alice!  What's your name?
#   > Bob
#   $ echo $name
#   Bob
#   $ prompt choice rock paper scissors <<EOF
#   OK, $name. I challenge you!
#   Rock, paper, scissors...
#   EOF
#   OK, Bob. I challenge you!  Rock, paper, scissors...
#   [rock|paper|scissors]> butterfingers
#   [rock|paper|scissors]> scissors
#   $ echo "$name chose $choice"
#   Bob chose scissors
#   $ rand=`shuf -i0-2 -n1 | sed -es/0/rock/ -es/1/paper/ -es/2/scissors/`
#   $ echo "Alice chose $rand"
#   Alice chose rock
#   $ prompt <<EOF
#   Press ENTER to continue:
#   EOF
#   Press ENTER to continue:

# Environment:
: ${PROMPT_OPEN='['}
: ${PROMPT_DELIM='|'}
: ${PROMPT_CLOSE=']'}
: ${PROMPT_PS1='> '}

prompt()
{
    # Format STDIN to STDOUT, discarding final newline
    fmt -`tput cols` | awk '
         NR == 1 { s = $0 }
         NR > 1  { s = s "\n" $0 }
         END     { printf s }'

    case $# in
    0)
        # Simply wait for a newline on the terminal input
        local prompt_next
        read prompt_next </dev/tty ;;
    1)
        # ${1}: Identifier of global variable to hold response value
        local prompt_variable=$1

        # Keep prompting until a non-empty string has been entered
        local prompt_value
        echo
        while :
        do
            # Simple prompt string
            printf "$PROMPT_PS1"

            # Read input from terminal
            eval "read $prompt_variable </dev/tty"
            prompt_value=`eval echo\ \"\\$$prompt_variable\"`

            # Return when the string is not empty
            test "X$prompt_value" = X || return 0

            # Sound an error tone and try again
            printf '\a'
        done ;;
    *)
        # ${1}: Identifier of global variable to hold response value
        local prompt_variable=$1

        # ${N}: Last option in list to be presented to the user
        local prompt_last=`eval echo\ \"\\$$#\"`

        # Remove ${1} and ${N} from positional parameters
        shift
        local prompt_unshift='set x'
        while test $# -gt 1
        do
            prompt_unshift="$prompt_unshift $1"
            shift
        done
        eval "$prompt_unshift"
        shift

        # Build prompt string
        local prompt_str=$PROMPT_OPEN
        for prompt_opt
        do
            prompt_str=$prompt_str$prompt_opt$PROMPT_DELIM
        done
        prompt_str=$prompt_str$prompt_last$PROMPT_CLOSE$PROMPT_PS1

        # Keep prompting until a valid selection has been made
        echo
        while :
        do
            # Present the user with a list of valid options
            printf "$prompt_str"

            # Read input from terminal
            eval "read $prompt_variable </dev/tty"

            # Check input against list of valid options
            prompt_value=`eval echo\ \"\\$$prompt_variable\"`
            for arg in "$@" "$prompt_last"
            do
                # Return when there is a match
                test "X$arg" = "X$prompt_value" && return 0
            done

            # Sound an error tone and try again
            printf '\a'
        done ;;
    esac
}
