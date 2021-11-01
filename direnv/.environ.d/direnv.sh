if [ "$BASH_VERSION" ]; then
    eval "`direnv hook bash`"
elif [ "$ZSH_VERSION" ]; then
    eval "`direnv hook zsh`"
fi
