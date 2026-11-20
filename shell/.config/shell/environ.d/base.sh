# Shell and terminal settings must be explicitly defined in each interactive
# shell and tmux pane (pty device).

# Use Emacs-style line editing
set +o vi
set -o emacs

# Terminal settings
stty -ixon
