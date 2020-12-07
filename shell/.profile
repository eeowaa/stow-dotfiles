[ "$ZSH_VERSION" ] && echo >&2 "Sourcing: ${(%):-%N}"

# Include guard to prevent PATH-like variables set here and in ~/.profile.d/*
# from being repetitively modified
test ${__PROFILE_SOURCED+'X'} || {

# Path variables
# TODO: Add LDPATH, etc.  See the gcc(1) man page for inspiration.
PATH="\
$HOME/.local/bin:\
$HOME/.local/sbin:\
/usr/local/bin:\
/usr/local/sbin:\
/usr/bin:\
/usr/sbin:\
$PATH" export PATH

# Local directory variables
TMPDIR=/tmp export TMPDIR

# Editor variables (see also: ~/.profile.d/{vim,emacs}.sh)
if test -f /usr/bin/ed
then FCEDIT=/usr/bin/ed export FCEDIT
else FCEDIT=/usr/bin/vi export FCEDIT
fi

# XDG base directories
XDG_CONFIG_HOME=$HOME/.config
XDG_CACHE_HOME=$HOME/.cache
XDG_DATA_HOME=$HOME/.local/share
XDG_DATA_DIRS=/usr/local/share:/usr/share
XDG_CONFIG_DIRS=/etc/xdg
export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_DATA_DIRS XDG_CONFIG_DIRS

# XDG user directories
. "$XDG_CONFIG_HOME/user-dirs.dirs"
export \
XDG_DESKTOP_DIR \
XDG_DOWNLOAD_DIR \
XDG_TEMPLATES_DIR \
XDG_PUBLICSHARE_DIR \
XDG_DOCUMENTS_DIR \
XDG_MUSIC_DIR \
XDG_PICTURES_DIR \
XDG_VIDEOS_DIR

# XDG application runtime
: ${XDG_RUNTIME_DIR='/tmp'}
export XDG_RUNTIME_DIR

# Source each profile script
for profile in "$HOME/.profile.d"/*.sh
do . "$profile"
done

# Let it be known that our profile has been sourced!
__PROFILE_SOURCED=1 export __PROFILE_SOURCED

# Set environment to be sourced if in interactive mode
ENV=$XDG_CONFIG_HOME/shell/environment export ENV

# End include guard
}
