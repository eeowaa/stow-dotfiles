# This file *does not always get run*, in particular when running zsh as an
# interactive NON-LOGIN shell.

echo >&2 "Sourcing: ${(%):-%N}"

# Source generic Bourne Shell profile
[[ -f ~/.profile ]] && source ~/.profile

# ZSH-specific profile
export HISTFILE=$XDG_CACHE_HOME/zsh/history
