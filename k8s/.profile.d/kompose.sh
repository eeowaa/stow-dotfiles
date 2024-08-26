## Requires: kompose

if [ "$BASH_VERSION" ]
then kompose completion bash >"$BASH_COMPLETION_USER_DIR/completions/kompose"
elif [ "$ZSH_VERSION" ]
then kompose completion zsh >"$ZDOTDIR/site-functions/_kompose"
else echo >&2 'Kompose completion not available for current shell'
fi

# if [ "$BASH_VERSION" ]
# then
#     # Prefer system-wide completion to user-level completion
#     if [ -f /usr/share/bash-completion/completions/kubectl ]
#     then
#         # Delete user-level completion if system-wide completion exists
#         rm -f "$BASH_COMPLETION_USER_DIR/completions/kubectl"
#     else
#         kubectl completion bash >"$BASH_COMPLETION_USER_DIR/completions/kubectl"
#     fi
# elif [ "$ZSH_VERSION" ]
# then [ -f /usr/share/zsh/site-functions/_kubectl ] ||
#      if [ -f /usr/share/bash-completion/completions/kubectl ]
#      then complete -C kubectl_completer kubectl
#         kubectl completion zsh >"$ZDOTDIR/site-functions/_kubectl"
# else echo >&2 'Kubectl completion not available for current shell'
# fi
