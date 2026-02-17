# syntax=docker/dockerfile:1
ARG FEDORA_MAJOR_VERSION=42
ARG FEDORA_DE=base-atomic

FROM quay.io/fedora-asahi-remix-atomic-desktops/${FEDORA_DE}:${FEDORA_MAJOR_VERSION}

RUN dnf config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo && \
    dnf copr -y enable solopasha/hyprland && \
    dnf copr -y enable scottames/ghostty && \
    dnf copr -y enable avengemedia/dms && \
    dnf clean all

RUN --mount=type=cache,target=/var/cache/libdnf5 \
    dnf install -y \
    autoconf bison flex make automake \
    clang lld llvm gdb \
    openssl-devel libzstd-devel ostree-devel \
    libvirt libvirt-client \
    python3-pip \
    qt6-qtmultimedia \
    terminus-fonts-console \
    glib && \
    dnf clean all

RUN dnf remove -y firefox tcl && dnf clean all

RUN --mount=type=cache,target=/var/cache/libdnf5 \
    dnf install -y \
    ghostty \
    chezmoi \
    cava \
    cliphist \
    dgop \
    hyprland \
    socat \
    dms dms-greeter \
    mediawriter \
    k9s \
    lua5.1-lpeg \
    neomutt \
    neovim \
    niri \
    pre-commit \
    ripgrep \
    restic autorestic \
    matugen \
    tmux \
    zsh \
    waybar \
    zoxide \
    quickshell \
    wl-clipboard \
    tailscale && \
    dnf clean all

COPY setup-flatpaks.service /etc/systemd/system/setup-flatpaks.service

RUN systemctl enable tailscaled && \
    systemctl enable setup-flatpaks.service

RUN echo "vijay ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/vijay
RUN echo 'FONT="ter-v20b"' | tee /etc/vconsole.conf
