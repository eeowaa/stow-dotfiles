alias a='acronym'
open() {
    case `uname -s` in
    Linux)
        xdg-open "$1" ;;
    Darwin)
        open "$1" ;;
    CYGWIN_NT*)
        cygstart -o "$1" ;;
    MINGW*|MSYS*)
        start '' "$1" ;;
    *)  ${BROWSER:?} "$1" ;;
    esac
}
