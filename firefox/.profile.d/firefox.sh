case `uname -s` in
Linux)
    # Set the default browser to firefox at runlevels 4-5
    case `runlevel | cut -d' ' -f2` in
    [45])
        BROWSER=firefox
        export BROWSER
    esac
esac
