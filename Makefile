.DEFAULT_GOAL := all
srcdir := .

# Operating Systems
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
MACOS := 1
packages := macos
else ifeq ($(UNAME_S),Linux)
LINUX := 1
packages := linux
else ifneq (,$(findstring CYGWIN,$(UNAME_S))) # e.g. CYGWIN_NT-10.0
# Do not override the standard CYGWIN environment variable
# <https://cygwin.com/cygwin-ug-net/using-cygwinenv.html>
ifndef CYGWIN
CYGWIN := 1
unexport CYGWIN
endif
packages := cygwin linux
gitlinks := $(srcdir)/cygwin/.local/opt/cygtools/.git
cygwin: linux $(srcdir)/cygwin/.local/opt/cygtools/.git
endif

# Graphics
packages += X11

# WMs and DEs
packages += i3 # doesn't necessarily need X11

# Terminals
packages += xterm tmux
ifdef CYGWIN
packages += mintty
endif
xterm: X11

# Shells
packages += shell bash zsh
bash: shell
zsh: shell

# Editors
packages += emacs doom vim
ifdef MACOS
gitlinks += $(srcdir)/emacs/.local/src/build-emacs-for-macos/.git
emacs: $(srcdir)/emacs/.local/src/build-emacs-for-macos/.git
endif
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
ignore_vim    := .*\.sw[a-p]
ignore_emacs  := \#.*\#|\.\#.*
ignore_backup := .*\.bak|.*~|.*\.~[1-9]~
ignore_pcre   := ^($(ignore_vim)|$(ignore_emacs)|$(ignore_backup))$$
.PHONY: $(packages)
$(packages):
	stow --no-folding --ignore '$(ignore_pcre)' $@
$(gitlinks):
	git submodule update --init --recursive $(@D)
