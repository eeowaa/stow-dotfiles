# Reference: https://manpages.org/npm
#
# 1. Specify machine-independent user configuration as environment variables
#    in `NPM_CONFIG_KEY=value' format, where KEY is any key that would be found
#    in an npmrc file. For example:
#
#    NPM_CONFIG_CACHE=$XDG_CACHE_HOME/npm
#    NPM_CONFIG_TMP=$XDG_RUNTIME_DIR/npm
#    NPM_CONFIG_INIT_MODULE=$XDG_CONFIG_HOME/npm/config/npm-init.js
#    export NPM_CONFIG_CACHE NPM_CONFIG_TMP NPM_CONFIG_INIT_MODULE
#
# 2. Put machine-specific user configuration in ~/.npmrc, which is ignored
#    by stow-dotfiles.
