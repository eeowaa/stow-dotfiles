alias a='acronym'
open() {
    case "$(uname -r)" in
    *-Microsoft|*-microsoft-standard-WSL2)
        if [ -e "$1" ]; then set -- "$(wslpath -w "$1")"; fi
        powershell.exe -NoProfile Start-Process "$1" ;;
    *)
        case "$(uname -s)" in
        Linux)
            xdg-open "$1" ;;
        Darwin)
            open "$1" ;;
        CYGWIN_NT*)
            cygstart -o "$1" ;;
        MINGW*|MSYS*)
            start '' "$1" ;;
        *)  ${BROWSER:?} "$1" ;;
        esac ;;
    esac
}
