if [ "$DEBUG" ]; then
    echo "Sourcing: $BASH_SOURCE" >&2
fi

# Source generic Bourne Shell environment
[[ -f "$ENV" ]] && source "$ENV"

# Bash-specific environment (currently empty)
