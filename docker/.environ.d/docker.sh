# Rather than adding a detachKeys setting to ~/.docker/config.json, I've
# wrapped the docker command with a function that adds the equivalent
# --detach-keys flag to the appropriate subcommands (docker will fail if the
# --detach-keys flag is passed to incompatible subcommands).
#
# The reason for avoiding the config file is because docker will modify it
# on the fly per machine, but I want my personal settings to be
# machine-independent and synced across machines.

docker() {
    # Use perl to modify the argument list, avoiding bashisms
    perl -e '
for my $i (0 .. $#ARGV) {
    if ($ARGV[$i] =~ /^(?:attach|exec|run|start)$/) {
        splice(@ARGV, $i + 1, 0, "--detach-keys", "ctrl-z,z");
        last;
    }
}
exec "docker", @ARGV;' ${1+"$@"}
}