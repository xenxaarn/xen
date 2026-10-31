FROM quay.io/fedora/fedora-bootc:44

# minimal gnome + apps
RUN dnf install -y --setopt=install_weak_deps=False \
    gnome-shell gdm gnome-session-wayland-session gnome-control-center \
    nautilus xdg-desktop-portal-gnome xdg-user-dirs-gtk gnome-keyring \
    loupe adw-gtk3-theme kitty neovim gnome-disk-utility firefox mozilla-openh264 \
    git curl wget btop fastfetch vlc \
    NetworkManager-wifi bluez power-profiles-daemon firewalld \
    pipewire pipewire-pulseaudio wireplumber flatpak \
    mesa-dri-drivers mesa-vulkan-drivers linux-firmware \
    rsms-inter-fonts jetbrains-mono-fonts-all google-noto-emoji-fonts \
 && dnf clean all

# dev tools
RUN dnf install -y --setopt=install_weak_deps=False \
    gcc gcc-c++ clang clang-tools-extra cmake ninja-build make gdb lldb valgrind \
    pkgconf-pkg-config openssl-devel \
    rust cargo rustfmt clippy rust-analyzer \
    python3 python3-pip python3-devel \
    nodejs npm golang \
 && dnf clean all

COPY files/dconf /etc/dconf/db/local.d/00
RUN mkdir -p /etc/dconf/profile \
 && printf 'user-db:user\nsystem-db:local\n' > /etc/dconf/profile/user \
 && dconf update

RUN printf 'export EDITOR=nvim\nexport VISUAL=nvim\n' > /etc/profile.d/editor.sh

COPY files/flatpaks.service /usr/lib/systemd/system/flatpaks.service

RUN systemctl enable gdm NetworkManager bluetooth power-profiles-daemon firewalld flatpaks \
 && systemctl set-default graphical.target

RUN sed -i 's/^NAME=.*/NAME="Xen"/; s/^PRETTY_NAME=.*/PRETTY_NAME="Xen"/' /usr/lib/os-release

RUN bootc container lint
