# This file *does not always get run*, in particular when running zsh as an
# interactive NON-LOGIN shell.

if [ "$DEBUG" ]; then echo >&2 "Sourcing: ${(%):-%N}"; fi

# Source generic Bourne Shell profile
[[ -f ~/.profile ]] && source ~/.profile

# ZSH-specific profile (currently empty)
