.DEFAULT_GOAL := all
srcdir := .
prefix := $(HOME)

# Command flags
# Patterns are added to Stow's builtin ignore list
# <https://www.gnu.org/software/stow/manual/html_node/Types-And-Syntax-Of-Ignore-Lists.html>
ignore_vim    := .*\.sw[a-p]
ignore_backup := .*\.bak|.*\.~[1-9]~
ignore_pcre   := ^($(ignore_vim)|$(ignore_backup))$$
STOWFLAGS     := --no-folding --ignore '$(ignore_pcre)'
GITFLAGS      := --init --recursive 

# Operating Systems
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
MACOS := 1
packages := macos
else ifeq ($(UNAME_S),Linux)
UNAME_R := $(shell uname -r)
ifneq (,$(findstring WSL2,$(UNAME_R))) # e.g. 5.10.16.3-microsoft-standard-WSL2
WSL2 := 1
packages := wsl2
else
LINUX := 1
packages := linux
endif
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
packages += X11 gimp

# Media
packages += ffmpeg

# WMs and DEs
packages += i3

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

# Editors - Vim
packages += vim
gitlinks += $(srcdir)/vim/.vim/pack/eeowaa/.git
vim: $(srcdir)/vim/.vim/pack/eeowaa/.git
vim-postinstall:
	cd $(prefix)/.vim && chmod 700 undo swap backup viminfo

# Editors - Emacs
packages += emacs
ifdef MACOS
gitlinks += $(srcdir)/emacs/.local/src/emacs/build-emacs-for-macos/.git
emacs: $(srcdir)/emacs/.local/src/emacs/build-emacs-for-macos/.git
endif

# Editors - Doom Emacs
packages += doom
doomdirs := $(addprefix $(srcdir)/doom/.local/src/doom/,hlissner/doom-emacs-private/.git tecosaur/emacs-config/.git)
gitlinks += $(doomdirs) $(srcdir)/doom/.config/doom/.git
$(doomdirs): GITFLAGS := $(filter-out --recursive,$(GITFLAGS))
doom: STOWFLAGS := $(filter-out --no-folding,$(STOWFLAGS))
doom: emacs $(doomdirs) $(srcdir)/doom/.config/doom/.git

# Pagers
packages += bat less

# Browsers
packages += wget lynx firefox

# Security
packages += bw gnupg openssl ssh

# Development
packages += direnv gdb git irc

# Languages
packages += dotnet go node perl python rust

# Platforms
packages += aws az k8s docker flatpak
k8s: utils

# Databases
packages += ldap mongo redis elastic
redis: docker

# Automation
packages += ansible topgrade

# Reference
packages += info locate org units
gitlinks += $(srcdir)/org/org/.git
org: $(srcdir)/org/org/.git

# Miscellaneous
packages += utils work
gitlinks += $(srcdir)/utils/.local/opt/mailconvert/.git
utils: $(srcdir)/utils/.local/opt/mailconvert/.git

# Local Configuration
.PHONY: dist configure
exampleconf := $(srcdir)/example-local.mk
localconf   := $(srcdir)/local.mk
dist:
	printf '# Override packages\npackages := \\\n' >$(exampleconf)
	ls -l $(srcdir) \
	| awk '/^d/ && $$NF !~ /^\./ { printf $$NF " " }' \
	| fmt \
	| sed -e 's/$$/ \\/' -e '$$s/ \\$$//' >>$(exampleconf)
configure:
	-direnv allow .
	-cp -n $(exampleconf) $(localconf)
	$(EDITOR) $(localconf)
ifneq (,$(wildcard $(localconf)))
include $(localconf)
else
$(warning WARNING: File does not exist: $(localconf))
endif

# Composite
.PHONY: all submodules
all: $(packages)
submodules: $(gitlinks)

# Meta
.PHONY: list listdeps test
null :=
space := $(null) $(null)
define newline


endef
list:
	@: $(info $(subst $(space),$(newline),$(sort $(packages))))
listdeps:
	$(srcdir)/.bin/listdeps
test:
	stow -d $(srcdir) -t $(prefix) $(STOWFLAGS) -nv $(packages)

# Recipes
preinstall_targets  := $(addsuffix -preinstall,$(packages))
install_targets     := $(addsuffix -install,$(packages))
postinstall_targets := $(addsuffix -postinstall,$(packages))
.PHONY: $(preinstall_targets) $(install_targets) $(postinstall_targets) $(packages)
$(install_targets): %-install: %-preinstall
	stow -d $(srcdir) -t $(prefix) $(STOWFLAGS) $*
$(postinstall_targets): %-postinstall: %-install
$(packages): %: %-postinstall
$(gitlinks):
	git -C $(srcdir) submodule update $(GITFLAGS) $(patsubst $(srcdir)/%,%,$(@D))
