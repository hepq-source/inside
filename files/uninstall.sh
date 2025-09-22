#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
    exec sudo "$0" "$@"
    exit 1
fi

systemctl disable inside
systemctl stop inside
rm /usr/lib/systemd/system/inside.service
echo "You can now delete the folder - /opt/inside"
