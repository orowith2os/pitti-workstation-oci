# Experiment: Martin Pitt's desktop OSTree as OCI container

I have maintained a [custom minimal Sway OSTree repo](https://piware.de/post/2020-12-13-ostree-sway/)
for quite some time in my [ostree-pitti-workstation project](https://github.com/martinpitt/ostree-pitti-workstation) . This works well, but needs some custom infrastructure to
publish the OSTree, and maintaining the project is not as easy as it could be.

A recent and cool new OSTree feature is
[ostree native containers](https://coreos.github.io/rpm-ostree/container/),
which allows developers to re-use the excellent container tools and
infrastructure to build and deliver trees.

## Installation

You need to run an existing OSTree based system like [Fedora CoreOS](https://getfedora.org/coreos) or [Fedora Silverblue](https://docs.fedoraproject.org/en-US/fedora-silverblue/). Switch to this tree with:

```sh
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/martinpitt/pitti-workstation-oci:latest
```

After that, you can install weekly updates with

```
sudo rpm-ostree upgrade
```

If anything goes wrong, you can go back to the previous version with `sudo rpm-ostree rollback`.

## Login

There is no graphical login manager. I log in on VT1, and my `.bashrc`
automatically starts the GNOME SSH agent and sway:

```sh
if [ "$(tty)" = "/dev/tty1" ]; then
    export `gnome-keyring-daemon --start --components=ssh`
    export BROWSER=firefox-wayland
    export XDG_CURRENT_DESKTOP=sway
    exec sway > $XDG_RUNTIME_DIR/sway.log 2>&1
fi
```

## Caveats

 * There is an 1.5 minute delay during boot as the initrd waits for some non-existing `dev-disk-by\x2dlabel-root.device` in the initrd. The OS removes all the ignition/coreos-installer bits, but dracut does not get updated properly for that. The workaround is to rename your root partition from "fedora" to "root".
 * The `man` command is missing
