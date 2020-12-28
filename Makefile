.DEFAULT_GOAL := all
srcdir := .

# Operating Systems
packages += linux macos cygwin
gitlinks += $(srcdir)/cygwin/.local/opt/cygtools/.git
cygwin: linux locate mintty $(srcdir)/cygwin/.local/opt/cygtools/.git

# Graphics
packages += X11

# WMs and DEs
packages += i3 # doesn't necessarily need X11

# Terminals
packages += xterm mintty tmux
xterm: X11

# Shells
packages += shell bash zsh
bash: shell
zsh: shell

# Editors
packages += emacs doom vim
gitlinks += $(srcdir)/doom/.config/doom/.git $(srcdir)/vim/.vim/pack/eeowaa/.git
doom: emacs $(srcdir)/doom/.config/doom/.git
vim: $(srcdir)/vim/.vim/pack/eeowaa/.git

# Languages
packages += dotnet go node perl python

# Browsers
packages += lynx

# Uncategorized
packages += aws direnv gimp git gnupg info irc less locate ssh-agent units utils wget work
gitlinks += $(srcdir)/utils/.local/opt/mailconvert/.git
utils: $(srcdir)/utils/.local/opt/mailconvert/.git

# Composite
.PHONY: all submodules
all: $(packages)
submodules: $(gitlinks)

# Meta
.PHONY: list
null :=
space := $(null) $(null)
define newline


endef
list:
	@: $(info $(subst $(space),$(newline),$(sort $(packages))))

# Recipes
.PHONY: $(packages)
$(packages):
	stow --no-folding $@
$(gitlinks):
	git submodule update --init --recursive $(@D)
