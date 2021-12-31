## Requires: minikube

if [ "$BASH_VERSION" ]
then minikube completion bash >"$BASH_COMPLETION_USER_DIR/completions/minikube"
elif [ "$ZSH_VERSION" ]
then minikube completion zsh >"$ZDOTDIR/site-functions/_minikube"
else echo >&2 'Minikube completion not available for current shell'
fi
