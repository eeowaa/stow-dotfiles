DOCKER_DETACH_KEYS='ctrl-z,z'
export DOCKER_DETACH_KEYS

# Rootless Docker daemon
DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
export DOCKER_HOST
