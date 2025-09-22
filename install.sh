#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
    exec sudo "$0" "$@"
    exit 1
fi

rm /usr/lib/systemd/system/inside.service > /dev/null 2>&1
rm -rf /opt/inside > /dev/null 2>&1
killall nfqws > /dev/null 2>&1

mkdir -p /opt/inside
cp -r ./files/* /opt/inside/

arch=$(uname -m)
case "$arch" in
    x86_64)
        bin_dir="x86_64"
        ;;
    i386|i686)
        bin_dir="x86"
        ;;
    armv7l|armv6l)
        bin_dir="arm"
        ;;
    aarch64)
        bin_dir="arm64"
        ;;
    *)
        echo "Unknown architecture: $arch"
        exit 1
        ;;
esac

cp "./bins/$bin_dir/nfqws" /opt/inside/system/
chmod +x /opt/inside/system/nfqws

echo "Select the firewall type:"
echo "1. iptables"
echo "2. nftables"
read -p "Enter number (1 or 2): " choice
case $choice in
    1)
        echo "iptables" > /opt/inside/system/FWTYPE
        echo "The firewall type is installed: iptables"
        ;;
    2)
        echo "nftables" > /opt/inside/system/FWTYPE
        echo "The firewall type is installed: nftables"
        ;;
    *)
        echo "Error: Wrong choice. Please select 1 or 2."
        exit 1
        ;;
esac

if command -v systemctl >/dev/null 2>&1 && [ -d /run/systemd ]; then

    cat <<EOF > /usr/lib/systemd/system/inside.service
[Unit]
Description=inside
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/inside
ExecStart=/bin/bash /opt/inside/system/starter.sh
ExecStop=/bin/bash /opt/inside/system/stopper.sh

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl start inside
    systemctl enable inside
    echo "The installation is complete. Inside is now in the /opt/inside folder, the Downloads folder can be deleted."

elif command -v openrc-run >/dev/null 2>&1 || [ -d /run/openrc ]; then
    cat <<EOF > /etc/init.d/inside
#!/sbin/openrc-run

name="inside"
description="inside service"
command="/bin/bash"
command_args="/opt/inside/system/starter.sh"
pidfile="/run/inside.pid"

start_pre() {
    checkpath --directory /run
}

stop() {
    /bin/bash /opt/inside/system/stopper.sh
}
EOF
    chmod +x /etc/init.d/inside
    rc-update add inside default
    rc-service inside start
    echo "The installation is complete. Inside is now in the /opt/inside folder, the Downloads folder can be deleted."
else
    echo "The initialization system could not be determined (systemd or OpenRC were not found)."
    exit 1
fi
