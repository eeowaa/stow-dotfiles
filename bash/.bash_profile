if [ "$DEBUG" ]; then
    echo "Sourcing: $BASH_SOURCE" >&2
fi

# Source generic Bourne Shell profile
[[ -f ~/.profile ]] && source ~/.profile

# Bash-specific profile
export INPUTRC=$XDG_CONFIG_HOME/readline/inputrc
export HISTFILE=$XDG_CACHE_HOME/bash/history
export BASH_COMPLETION_USER_DIR=$XDG_DATA_HOME/bash-completion

# Spruce up the interactive shell experience
case $- in
*i*)
    [[ -f ~/.bashrc ]] && source ~/.bashrc
esac
