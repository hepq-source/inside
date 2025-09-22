#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

if pidof "nfqws" > /dev/null; then
    killall nfqws
fi

if [ -f /opt/inside/system/FWTYPE ]; then
    content=$(cat /opt/inside/system/FWTYPE)
    if [ "$content" = "iptables" ]; then
        FWTYPE=iptables
    elif [ "$content" = "nftables" ]; then
        FWTYPE=nftables
    else
        echo "Error: invalid file FWTYPE."
        exit 1
    fi
    echo "FWTYPE=$FWTYPE" 2>/dev/null
else
    echo "Error: File /opt/inside/system/FWTYPE not found."
    exit 1
fi

if [ "$FWTYPE" = "iptables" ]; then
    iptables -t mangle -F PREROUTING
    iptables -t mangle -F POSTROUTING
elif [ "$FWTYPE" = "nftables" ]; then
    nft flush table inet inside 2>/dev/null || true
    nft delete table inet inside 2>/dev/null || true
fi
