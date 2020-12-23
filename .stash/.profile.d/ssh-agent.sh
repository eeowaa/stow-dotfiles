(
    # Redirect stdout to stderr for this subshell
    exec >&2

    # Check for an existing socket
    test -f "$XDG_CACHE_HOME/ssh/auth_sock" || {
        echo "Missing file: $XDG_CACHE_HOME/ssh/auth_sock"
        exit 1
    }
    read SSH_AUTH_SOCK < "$XDG_CACHE_HOME/ssh/auth_sock"
    test -S "$SSH_AUTH_SOCK" || {
        echo "Missing socket: $SSH_AUTH_SOCK"
        exit 1
    }

    # Check for an existing process
    test -f "$XDG_CACHE_HOME/ssh/agent_pid" || {
        echo "Missing file: $XDG_CACHE_HOME/ssh/agent_pid"
        exit 1
    }
    read SSH_AGENT_PID < "$XDG_CACHE_HOME/ssh/agent_pid"
    expr "X$SSH_AGENT_PID" : 'X[1-9][0-9]*$' >/dev/null || {
        echo "Invalid PID: $SSH_AGENT_PID"
        exit 1
    }
    kill -0 "$SSH_AGENT_PID" || {
        echo "Stale PID: $SSH_AGENT_PID"
        exit 1
    }

) || {
    # Start new SSH agent
    eval `ssh-agent`
    echo $SSH_AUTH_SOCK > "$XDG_CACHE_HOME/ssh/auth_sock"
    echo $SSH_AGENT_PID > "$XDG_CACHE_HOME/ssh/agent_pid"
}
