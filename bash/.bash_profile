if [ "$DEBUG" ]; then
    echo "Sourcing: $BASH_SOURCE" >&2
fi

# Source generic Bourne Shell profile
[[ -f ~/.profile ]] && source ~/.profile

# Bash-specific profile
export INPUTRC=$XDG_CONFIG_HOME/readline/inputrc
export HISTFILE=$XDG_CACHE_HOME/bash/history

# When running interactively, spruce up the experience
case $- in
*i*)
    # Set the command prompt
    # https://www.howtogeek.com/307701/how-to-customize-and-colorize-your-bash-prompt/
    function my_ps1
    {
        # This could be much more readable, but this function must be optimized
        # in order to avoid delay on slower platforms (read: Cygwin)
        if [ $? -eq 0 ]
        then export PS1='\[\033[1;30m\][\j] \[\033[2;37m\]\w \[\033[00m\]\$ '
        else export PS1='\[\033[1;30m\][\j] \[\033[2;37m\]\w \[\033[1;31m\]\$\[\033[00m\] '
        fi
    }
    export -f my_ps1
    export PROMPT_COMMAND=my_ps1
    export PROMPT_DIRTRIM=2

    # Load other user preferences
    [[ -f ~/.bashrc ]] && source ~/.bashrc
esac
