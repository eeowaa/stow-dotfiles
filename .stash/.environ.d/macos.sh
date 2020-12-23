# Ignore errors from `man', `apropos', and `whatis'
# <https://discussions.apple.com/thread/807894>
# <https://apple.stackexchange.com/questions/374025/errors-from-whatis-command-unable-to-rebuild-database-with-makewhatis>
alias man='/usr/bin/man 2>/dev/null'
alias apropos='/usr/bin/apropos 2>/dev/null'
alias whatis='/usr/bin/whatis 2>/dev/null'
