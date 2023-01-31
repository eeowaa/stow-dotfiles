## Requires: runlevel
LYNX_CFG=$XDG_CONFIG_HOME/lynx/lynx.cfg
LYNX_LSS=$XDG_CONFIG_HOME/lynx/lynx.lss
export LYNX_CFG LYNX_LSS

case `uname -s` in
Linux)
    # Set the default browser to lynx at runlevels 1-3
    case `runlevel | cut -d' ' -f2` in
    [123])
        BROWSER=lynx
        export BROWSER
    esac
esac
