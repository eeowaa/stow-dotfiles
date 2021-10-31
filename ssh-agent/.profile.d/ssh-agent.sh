## Requires: ssh-agent
{
    read SSH_AUTH_SOCK < "$XDG_CACHE_HOME/ssh/auth_sock" && test -S "$SSH_AUTH_SOCK" &&
    read SSH_AGENT_PID < "$XDG_CACHE_HOME/ssh/agent_pid" && kill -0 "$SSH_AGENT_PID" &&
    export SSH_AUTH_SOCK SSH_AGENT_PID
} 2>/dev/null || {
    eval `ssh-agent`
    echo $SSH_AUTH_SOCK > "$XDG_CACHE_HOME/ssh/auth_sock"
    echo $SSH_AGENT_PID > "$XDG_CACHE_HOME/ssh/agent_pid"
}
