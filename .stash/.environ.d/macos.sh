# Ignore errors from `man', `apropos', and `whatis'
# <https://discussions.apple.com/thread/807894>
# <https://apple.stackexchange.com/questions/374025/errors-from-whatis-command-unable-to-rebuild-database-with-makewhatis>
_alias man '/usr/bin/man 2>/dev/null'
_alias apropos '/usr/bin/apropos 2>/dev/null'
_alias whatis '/usr/bin/whatis 2>/dev/null'
