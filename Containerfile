FROM quay.io/fedora/fedora-bootc:44

# minimal gnome + apps
RUN dnf install -y --setopt=install_weak_deps=False \
    gnome-shell gdm gnome-session-wayland-session gnome-control-center \
    nautilus xdg-desktop-portal-gnome xdg-user-dirs-gtk gnome-keyring \
    loupe adw-gtk3-theme kitty neovim gnome-disk-utility firefox mozilla-openh264 \
    git curl wget btop fastfetch vlc \
    NetworkManager-wifi bluez power-profiles-daemon firewalld \
    pipewire pipewire-pulseaudio wireplumber flatpak gnome-extensions-app \
    mesa-dri-drivers mesa-vulkan-drivers linux-firmware \
    rsms-inter-fonts jetbrains-mono-fonts-all google-noto-emoji-fonts \
 && dnf clean all

# dev tools
RUN dnf install -y --setopt=install_weak_deps=False \
    gcc gcc-c++ clang clang-tools-extra cmake ninja-build make gdb lldb valgrind \
    pkgconf-pkg-config openssl-devel \
    python3 python3-pip python3-devel \
 && dnf clean all

# Extensions
COPY files/extensions.txt /tmp/extensions.txt
RUN set -e; \
    v=$(rpm -q --qf '%{VERSION}' gnome-shell); v=${v%%.*}; \
    d=/usr/share/gnome-shell/extensions; list=""; \
    while read -r u; do \
      case "$u" in ''|\#*) continue;; esac; \
      p=$(curl -fsSL "https://extensions.gnome.org/extension-info/?uuid=$u&shell_version=$v" \
          | python3 -c 'import sys,json;print(json.load(sys.stdin)["download_url"])'); \
      curl -fsSL -o /tmp/e.zip "https://extensions.gnome.org$p"; \
      python3 -m zipfile -e /tmp/e.zip "$d/$u"; \
      if [ -d "$d/$u/schemas" ]; then glib-compile-schemas "$d/$u/schemas"; fi; \
      list="${list:+$list, }'$u'"; \
    done < /tmp/extensions.txt; \
    mkdir -p /etc/dconf/db/local.d; \
    printf '[org/gnome/shell]\nenabled-extensions=[%s]\n' "$list" > /etc/dconf/db/local.d/01-extensions; \
    rm -f /tmp/e.zip /tmp/extensions.txt

COPY files/dconf /etc/dconf/db/local.d/00
RUN mkdir -p /etc/dconf/profile \
 && printf 'user-db:user\nsystem-db:local\n' > /etc/dconf/profile/user \
 && dconf update

RUN printf 'export EDITOR=nvim\nexport VISUAL=nvim\n' > /etc/profile.d/editor.sh

COPY files/flatpaks.service /usr/lib/systemd/system/flatpaks.service

RUN systemctl enable gdm NetworkManager bluetooth power-profiles-daemon firewalld flatpaks \
 && systemctl set-default graphical.target \
 && systemctl mask systemd-remount-fs.service

RUN sed -i 's/^NAME=.*/NAME="Xen"/; s/^PRETTY_NAME=.*/PRETTY_NAME="Xen"/' /usr/lib/os-release

RUN bootc container lint
