# Produce coredumps instead of stackdumps upon crash.  To debug, you will
# need to install `gdb' and the relevant `*-debuginfo' packages and run
# `gdb /PATH/TO/EXE /PATH/TO/COREDUMP'.
CYGWIN='error_start=dumper -d %1 %2"'
export CYGWIN

# Include cygtools and native Windows binaries in PATH
PATH=$PATH:$HOME/.local/opt/cygtools/bin:/usr/local/wbin
export PATH
