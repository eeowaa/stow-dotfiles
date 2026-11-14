# Use the system ripgrep (if available) for lower overhead in "Grep" tool calls
which rg >/dev/null 2>&1
USE_BUILTIN_RIPGREP=$?
export USE_BUILTIN_RIPGREP
