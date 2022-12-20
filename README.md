# Experiment: Martin Pitt's desktop OSTree from Fedora OCI container

I have maintained a [custom minimal Sway OSTree repo](https://piware.de/post/2020-12-13-ostree-sway/)
for quite some time in my [ostree-pitti-workstation project](https://github.com/martinpitt/ostree-pitti-workstation) . This works well, but is relatively complex to maintain.

So instead of building the tree from scratch, this project is an experiment for
building it from a [Fedora CoreOS base image](https://quay.io/repository/fedora/fedora-coreos).
CoreOS is not a very good fit for hardware installation, as it does not ship
enough drivers, but a lot of stuff that does not belong onto a laptop, such as
Ignition, zincati, or the coreos-installer. But there is [work underway](https://pagure.io/releng/issue/11047) to provide more minimal base images or [Fedora IoT](https://getfedora.org/iot/), which would make this a lot nicer.

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
