# Fedora has official packages for all of the prerequisites
FROM fedora:41

# TLS certificate validation currently fails for the Cisco H.264 codec repos.
# We do not need any of the packages in those repos, so we simply ignore them.
RUN dnf makecache --disablerepo='fedora-cisco-openh264*' && \
    dnf install -y direnv git make stow tree vim && \
    rm -rf /var/cache/dnf
