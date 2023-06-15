if [ "$DEBUG" ]; then
    echo >&2 "Sourcing: ${(%):-%N}"
fi

### The following must come *before* sourcing the POSIX shell environment:

# Set ZSH prompt string
# TODO: Add leading "..." to shortened directory paths
# TODO: Use the same colors as bash does for the prompt
autoload -Uz colors
colors
PS1='%F{magenta}[%j]%f %2c %(?.%F{green}.%F{red})$%f '

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

### Source the POSIX shell environment:

# XXX: Set ENV here because ~/.profile is not sourced in interactive non-login zsh shells
ENV=$XDG_CONFIG_HOME/shell/environment
[[ -f "$ENV" ]] && source "$ENV"

### The following must come *after* sourcing the POSIX shell environment:

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

### The following can go anywhere in .zshrc:

# Set the history file
# XXX: Cannot set HISTFILE in $ZDOTDIR/.zprofile because /etc/zshrc overrides it on macOS
export HISTFILE=$XDG_CACHE_HOME/zsh/history

# Have all ZSH instances write to the same history file
# FIXME: This is not working as intended
# <https://askubuntu.com/questions/23630/how-do-you-share-history-between-terminals-in-zsh>
# <https://unix.stackexchange.com/questions/111718/command-history-in-zsh>
setopt inc_append_history

# Ignore comments in interactive command lines
# <https://unix.stackexchange.com/questions/33994/zsh-interpret-ignore-commands-beginning-with-as-comments>
setopt interactivecomments

# Prevent "%" symbols from showing in Emacs terminals (specifically vterm)
# <https://unix.stackexchange.com/questions/167582/why-zsh-ends-a-line-with-a-highlighted-percent-symbol>
unsetopt prompt_cr prompt_sp
