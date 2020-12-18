.DEFAULT_GOAL := all

# Operating Systems
targets += linux macos cygwin
cygwin: locate

# Terminals
targets += xterm iterm2 mintty tmux
tmux: shell

# Shells
targets += shell bash zsh
bash: shell
zsh: shell

# Editors
targets += vim emacs doom
doom: emacs

# Languages
targets += go node perl python

# Browsers
targets += lynx

# Other
targets += aws direnv git X11 i3

.PHONY: $(targets)
$(targets):
	stow --no-folding $@

.PHONY: all
all: $(targets)
