# This is necessary for .desktop files of flatpak applications to be recognized
# by GNOME Wayland sessions in Fedora (at the very least). See VSC log for this
# file for context.
eval "`flatpak --print-updated-env`"
export XDG_DATA_DIRS
