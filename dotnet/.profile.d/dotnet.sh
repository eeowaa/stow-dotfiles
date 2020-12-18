case `uname -s` in
Darwin)
    MONOPATH=/Library/Frameworks/Mono.framework/Versions/Current/bin
    export MONOPATH ;;
*)
    # TODO: Add support for operating systems
esac

DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_CLI_TELEMETRY_OPTOUT
