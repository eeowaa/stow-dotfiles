# mailconvert
PATH=$PATH:$HOME/.local/opt/mailconvert/bin
export PATH

# jump
JUMP_OPTIONS="--exclude '*WorkDocs*'"
export JUMP_OPTIONS # passed to `fd`

# getpw
GETPW_BACKENDS='keychain bitwarden'
export GETPW_BACKENDS
