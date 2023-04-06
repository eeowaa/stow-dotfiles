## Colorize text with ANSI escape codes
## Usage: . "$SHELL_LIB_DIR/color.sh" [--all]

color() {
    local b c
    case $1 in
    --*black)   c=30 ;;
    --*red)     c=31 ;;
    --*green)   c=32 ;;
    --*yellow)  c=33 ;;
    --*blue)    c=34 ;;
    --*magenta) c=35 ;;
    --*cyan)    c=36 ;;
    --*white)   c=37 ;;
    *)  cat >&2 <<EOF
Usage: color --COLORNAME [STRING]
COLORNAME is one of: black, red, green, yellow, blue, magenta, cyan, white.
COLORNAME is optionally prefixed with "bright".
If STRING is not provided, it is read from stdin.
EOF
        return 1 ;;
    esac
    case $1 in
    --bright*)  b=1 ;;
    *)          b=0 ;;
    esac
    if [ $# -eq 1 ]
    then
        printf '\e[%s;%sm' ${b} ${c}
        cat
        printf '\e[0m'
    else
        shift
        printf '\e[%s;%sm' ${b} ${c}
        printf "$@"
        printf '\e[0m'
    fi
}

case $1 in
--all)
    # Define functions named after each color (standard and bright variations)
    for color in black red green yellow blue magenta cyan white
    do
        eval "$color()       { color --$color       \${1+\"\$@\"}; }"
        eval "bright$color() { color --bright$color \${1+\"\$@\"}; }"
    done ;;
esac
