## Requires: nvm npm

nvm_init() {
    # Remove command hooks for lazy-loading
    unalias nvm npm node 2>/dev/null

    # Load the NVM environment (expensive operation)
    [ -f "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
    [ -f "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

    # Override the `nvm_extract_tarball` function defined in `$NVM_DIR/nvm.sh`
    # on WSL 1 when bsdtar(1) is installed. The original function definition
    # invokes GNU tar(1) in such a way that calls mkdir(2) -- a syscall that is
    # not implemented on WSL 1. The function signature, error output, and
    # return codes are the same as `nvm_extract_tarball` in nvm 0.41.0.
    case `uname -r` in
    *-Microsoft)
        if which bsdtar >/dev/null 2>&1; then
            nvm_extract_tarball() {
                [ $# -eq 4 ] || {
                    nvm_err 'nvm_extract_tarball requires exactly 4 arguments'
                    return 5
                }
                command bsdtar -xf "$3" -C "$4" --strip-components 1 --no-same-owner || return 1
            }
        fi ;;
    esac

    # Execute original `nvm`, `npm`, or `node` command
    "$@"
}; _exportf nvm_init
