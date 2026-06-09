if [ "$BASH_VERSION" ]; then
    eval "$(direnv hook bash)"
    export -f _direnv_hook
    export PROMPT_COMMAND
elif [ "$ZSH_VERSION" ]; then
    eval "$(direnv hook zsh)"
fi
