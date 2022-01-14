# mailconvert
PATH=$PATH:$HOME/.local/opt/mailconvert/bin
export PATH

# jump
JUMP_OPTIONS="\
--exclude '*WorkDocs*' \
--exclude flatpak \
--exclude subvolumes"
JUMP_PATH=\
$XDG_DOCUMENTS_DIR:\
$XDG_DOWNLOAD_DIR:\
$XDG_DESKTOP_DIR:\
$XDG_PICTURES_DIR:\
$XDG_VIDEOS_DIR:\
$XDG_MUSIC_DIR:\
$XDG_PUBLICSHARE_DIR:\
$XDG_TEMPLATES_DIR:\
$XDG_CONFIG_HOME:\
$XDG_CACHE_HOME:\
$XDG_DATA_HOME
export JUMP_OPTIONS JUMP_PATH
