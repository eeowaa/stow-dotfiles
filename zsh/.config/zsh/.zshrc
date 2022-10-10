if [ "$DEBUG" ]; then
    echo >&2 "Sourcing: ${(%):-%N}"
fi

# Must come *before* sourcing POSIX shell environment {{{1
# --------------------------------------------------------
# Set ZSH prompt string {{{2
# TODO: Add leading "..." to shortened directory paths
# TODO: Use the same colors as bash does for the prompt
autoload -Uz colors
colors
PS1='%F{magenta}[%j]%f %2c %(?.%F{green}.%F{red})$%f '
# }}}2

# TODO: Initialize command completion {{{2
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
# }}}2
# }}}1

# Source POSIX shell environment {{{1
# -----------------------------------
# XXX: Although ~/.profile sets ENV, it *does not always get run*,
#      in particular when running zsh as an interactive NON-LOGIN shell)
ENV=$XDG_CONFIG_HOME/shell/environment
[[ -f "$ENV" ]] && source "$ENV"
# }}}1

# Must come *after* sourcing POSIX shell environment {{{1
# -------------------------------------------------------
# Command-line editing {{{2
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
# }}}2
# }}}1

# Can go anywhere in .zshrc {{{1
# -----------------------------
# Set the history file
# XXX: I would rather set this in $ZDOTDIR/.zprofile, but /etc/zshrc overwrites
#      it, at least on macOS
export HISTFILE=$XDG_CACHE_HOME/zsh/history

# <https://unix.stackexchange.com/questions/167582/why-zsh-ends-a-line-with-a-highlighted-percent-symbol>
# Prevent "%" symbols from showing in Emacs terminals (specifically vterm)
unsetopt prompt_cr prompt_sp
# }}}1
