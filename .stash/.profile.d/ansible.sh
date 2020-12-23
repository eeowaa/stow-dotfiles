# Config file
ANSIBLE_CONFIG=$XDG_CONFIG_HOME/ansible/ansible.cfg
export ANSIBLE_CONFIG

# Control paths
ANSIBLE_SSH_CONTROL_PATH_DIR=$XDG_CACHE_HOME/ansible/cp
PERSISTENT_CONTROL_PATH_DIR=$XDG_CACHE_HOME/ansible/pc
export ANSIBLE_SSH_CONTROL_PATH_DIR PERSISTENT_CONTROL_PATH_DIR

# Temporary files
DEFAULT_LOCAL_TMP=$XDG_CACHE_HOME/ansible/tmp
export DEFAULT_LOCAL_TMP

# Collections
ANSIBLE_COLLECTIONS_PATHS=\
$XDG_CONFIG_HOME/ansible/collections:\
/usr/local/share/ansible/collections:\
/usr/share/ansible/collections
export ANSIBLE_COLLECTIONS_PATHS

# Roles
ANSIBLE_ROLES_PATH=\
$XDG_CONFIG_HOME/ansible/roles:\
/usr/local/share/ansible/roles:\
/usr/share/ansible/roles:\
/etc/ansible/roles
export ANSIBLE_ROLES_PATH

# Plugins (including modules)
while read var name
do
    eval "ANSIBLE_$var=\
$XDG_CONFIG_HOME/ansible/plugins/$name:\
/usr/local/share/ansible/plugins/$name:\
/usr/share/ansible/plugins/$name
export ANSIBLE_$var"
done <<EOF
LIBRARY              modules
MODULE_UTILS         module_utils
ACTION_PLUGINS       action
BECOME_PLUGINS       become
CACHE_PLUGINS        cache
CALLBACK_PLUGINS     callback
CLICONF_PLUGINS      cliconf
CONNECTION_PLUGINS   connection
FILTER_PLUGINS       filter
HTTPAPI_PLUGINS      httpapi
INVENTORY_PLUGINS    inventory
LOOKUP_PLUGINS       lookup
NETCONF_PLUGINS      netconf
STRATEGY_PLUGINS     strategy
TERMINAL_PLUGINS     terminal
TEST_PLUGINS         test
VARS_PLUGINS         vars
DOC_FRAGMENT_PLUGINS doc_fragments
EOF
