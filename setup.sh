#!/bin/sh
set -xeuo pipefail

# Enable SysRQ
echo 'kernel.sysrq = 1' > /usr/lib/sysctl.d/90-sysrq.conf

# set up PAM for systemd-homed
authselect enable-feature with-systemd-homed

# homed is missing a lot of SELinux policy (https://bugzilla.redhat.com/show_bug.cgi?id=1809878)
# "disabled" breaks rpm-ostree (https://bugzilla.redhat.com/show_bug.cgi?id=1882933), so just use permissive
sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

## enable other units
ln -s ../systemd-timesyncd.service /usr/lib/systemd/system/sysinit.target.wants/systemd-timesyncd.service
ln -s ../cockpit.socket /usr/lib/systemd/system/sockets.target.wants/cockpit.socket

# disable unwanted services
ln -sfn /dev/null /usr/lib/systemd/user/at-spi-dbus-bus.service

# move OS systemd unit defaults to /usr
cp -a --verbose /etc/systemd/system /etc/systemd/user /usr/lib/systemd/
rm -r /etc/systemd/system /etc/systemd/user

# move system users for installed packages to /usr
cat /etc/group >> /usr/lib/group
cat /etc/passwd >> /usr/lib/passwd
rm /etc/passwd /etc/group /etc/*-

# we have nss-myhostname
truncate --size 0 /etc/hosts

# update for Red Hat certificate
ln -s /etc/pki/ca-trust/source/anchors/2015-RH-IT-Root-CA.pem /etc/pki/tls/certs/2015-RH-IT-Root-CA.pem
update-ca-trust
