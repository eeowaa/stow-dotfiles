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
packages += X11 gimp

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

# Editors
packages += emacs doom vim
ifdef MACOS
gitlinks += $(srcdir)/emacs/.local/src/build-emacs-for-macos/.git
emacs: $(srcdir)/emacs/.local/src/build-emacs-for-macos/.git
endif
gitlinks += $(srcdir)/doom/.config/doom/.git $(srcdir)/vim/.vim/pack/eeowaa/.git
doom: private STOWFLAGS := $(filter-out --no-folding,$(STOWFLAGS))
doom: emacs $(srcdir)/doom/.config/doom/.git
vim: $(srcdir)/vim/.vim/pack/eeowaa/.git

# Pagers
packages += bat less

# Browsers
packages += wget lynx firefox

# Security
packages += bw gnupg openssl ssh

# Development
packages += direnv git irc

# Languages
packages += dotnet go node perl python rust

# Platforms
packages += aws az k8s docker
k8s: utils

# Databases
packages += ldap mongo redis elastic
redis: docker

# Automation
packages += ansible

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
.PHONY: $(packages)
$(packages):
	stow -d $(srcdir) -t $(prefix) $(STOWFLAGS) $@
$(gitlinks):
	git -C $(srcdir) submodule update --init --recursive $(patsubst $(srcdir)/%,%,$(@D))
