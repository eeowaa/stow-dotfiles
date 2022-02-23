if [ "$DEBUG" ]; then
    echo >&2 "Sourcing: ${(%):-%N}"
fi

# TODO: Initialize command completion
# NOTE: These are the paths to look at:
# - /usr/share/zsh/5.8/functions/{bashcompinit,compinstall,compinit.compdump}
# - /usr/share/zsh/site-functions/{fzf,kompose,_code} # fzf is completion.zsh
# - ~/.config/zsh/site-functions
# - ~/.cache/zsh/zcompdump
# - /usr/share/fzf/shell/key-bindings.zsh
# - ~/.profile.d/
export fpath=($ZDOTDIR/site-functions $fpath)
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Set the history file
# (I would rather set this in $ZDOTDIR/.zprofile, but /etc/zshrc overwrites it,
# at least on macOS)
export HISTFILE=$XDG_CACHE_HOME/zsh/history

# Source POSIX shell environment
# (Although ~/.profile sets ENV, it *does not always get run*,
# in particular when running zsh as an interactive NON-LOGIN shell)
ENV=$XDG_CONFIG_HOME/shell/environment
[[ -f "$ENV" ]] && source "$ENV"

# Use bash-like word definitions for navigation and operations
autoload -Uz select-word-style
select-word-style bash

# Use C-w to kill back to the previous space
zle -N backward-kill-space-word backward-kill-word-match
zstyle :zle:backward-kill-space-word word-style space
bindkey '^W' backward-kill-space-word

# Use C-u to kill to the beginning of the line
bindkey '^U' backward-kill-line

# Use C-x C-e to edit the current command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

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
