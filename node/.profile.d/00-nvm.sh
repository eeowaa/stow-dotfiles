NVM_DIR=$XDG_CONFIG_HOME/nvm
export NVM_DIR

# Insert "$NVM_DIR/versions/node/.../bin" at the front of PATH so that programs
# installed with `nvm` can be found before lazy-loading the rest of NVM
unalias nvm npm node
[ -f "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
