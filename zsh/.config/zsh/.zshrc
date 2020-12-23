echo >&2 "Sourcing: ${(%):-%N}"

# Initialize command completion
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Source POSIX shell environment
# (Although ~/.profile sets ENV, it *does not always get run*,
# in particular when running zsh as an interactive NON-LOGIN shell)
ENV=$XDG_CONFIG_HOME/shell/environment
[[ -f "$ENV" ]] && source "$ENV"

# Use C-x C-e to edit the current command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey '^U' backward-kill-line

# <https://unix.stackexchange.com/questions/167582/why-zsh-ends-a-line-with-a-highlighted-percent-symbol>
# Prevent "%" symbols from showing in Emacs terminals (specifically vterm)
unsetopt prompt_cr prompt_sp

# ZSH prompt string
# TODO:
# - Add leading "..." to shortened directory paths
# - Use the same colors as bash does for the prompt
autoload -Uz colors
colors
PS1='%F{magenta}[%j]%f %F{white}%2c%f %(?.%F{green}.%F{red})$%f '
