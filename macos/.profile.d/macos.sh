# By default, Homebrew installs GNU utilities by prefixing each of their
# installed files with "g", thus avoiding name conflicts with existing tools.
#
# However, sometimes it is desireable to prefer the GNU version of a utility to
# the standard BSD version that ships with Darwin, without specifying the "g"
# prefix.  There are a few options: override the Homebrew installation process,
# alias commands as needed, or add to PATH and MANPATH as needed.
#
# For now, I prefer the third option, as I see this as being slightly easier
# to document my configuration.

__HOMEBREW_PREFIX=`brew --prefix`

# For each specified GNU utility installed by Homebrew
for gnubrew in coreutils findutils grep gawk gnu-units
do
    # Reference the packaged files _without_ "g" prefixes
    __libexec_prefix=$__HOMEBREW_PREFIX/opt/$gnubrew/libexec

    # Add the executables to the front of PATH
    test -d "$__libexec_prefix/gnubin" &&
        PATH=$__libexec_prefix/gnubin:$PATH

    # Add the man pages to the front of MANPATH
    test -d "$__libexec_prefix/gnuman" &&
        MANPATH=$__libexec_prefix/gnuman${MANPATH:+":$MANPATH"}
done
export PATH MANPATH

# TODO Homebrew configuration
HOMEBREW_NO_ANALYTICS=1
#HOMEBREW_CACHE=$XDG_CACHE_HOME/homebrew
#HOMEBREW_LOGS=$XDG_CACHE_HOME/homebrew/log
export HOMEBREW_NO_ANALYTICS # HOMEBREW_CACHE HOMEBREW_LOGS

###############################################################################

# Depending on how Emacs.app is installed, we need to create an `emacs` script
if [ -d /Applications/Emacs.app/Contents/MacOS/bin ]
then
    [ -f /Applications/Emacs.app/Contents/MacOS/bin/emacs ] || {
        cat >/Applications/Emacs.app/Contents/MacOS/bin/emacs <<'EOF'
#!/bin/sh
exec /Applications/Emacs.app/Contents/MacOS/Emacs ${1+"$@"}
EOF
        chmod +x /Applications/Emacs.app/Contents/MacOS/bin/emacs
    }
    PATH=/Applications/Emacs.app/Contents/MacOS/bin:$PATH
    export PATH
fi
