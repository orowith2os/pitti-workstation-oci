# stable has a too old authselect for homed support (needs 1.4.2)
FROM quay.io/fedora/fedora-coreos:testing

RUN rpm-ostree install \
    kernel-modules-extra iwl6000g2a-firmware iwl7260-firmware alsa-sof-firmware \
    NetworkManager-wifi NetworkManager-openvpn-gnome wpa_supplicant openvpn \
    glibc-langpack-de glibc-langpack-en \
    man-db fpaste tree nmap-ncat isync duplicity git patchutils make strace mtr \
    krb5-workstation \
    syncthing cockpit-ws cockpit-system \
    vim-enhanced mutt w3m weechat \
    man-db man-pages fd-find ripgrep \
    fedora-workstation-backgrounds gvfs-mtp pulseaudio-utils alsa-plugins-pulseaudio \
    dejavu-sans-fonts dejavu-serif-fonts dejavu-sans-mono-fonts fontawesome-fonts google-noto-emoji-color-fonts \
    xdg-desktop-portal-gtk pavucontrol pcmanfm nm-connection-editor gnome-keyring pinentry-gnome3 mate-polkit \
    eog evince lxterminal gnome-disk-utility rofimoji \
    sway swayidle swaylock kanshi mako waybar slurp grim xorg-x11-server-Xwayland \
    flatpak distrobox \
    wofi brightnessctl wl-clipboard && \
    \
    rpm-ostree override remove -n adcli chrony clevis clevis-luks clevis-dracut clevis-systemd \
    coreos-installer coreos-installer-bootinfra ignition \
    iscsi-initiator-utils iscsi-initiator-utils-iscsiuio isns-utils-libs \
    moby-engine NetworkManager-team teamd zincati lvm2 lvm2-libs && \
    \
    rm -r /var/* && \
    ostree container commit

COPY trust-anchors/ /etc/pki/ca-trust/source/anchors/

COPY setup.sh /

RUN sh /setup.sh && \
    rm /setup.sh && \
    ostree container commit
