# The first time any one of these commands are run in the current shell, the
# `nvm_init` function will run and lazy-load the NVM environment
alias nvm='nvm_init nvm'
alias npm='nvm_init npm'
alias node='nvm_init node'

nvm_init() {
    # Remove command hooks for lazy-loading
    unalias nvm npm node

    # Load the NVM environment (expensive operation)
    [ -f "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -f "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

    # Execute original `nvm`, `npm`, or `node` command
    "$@"
}
