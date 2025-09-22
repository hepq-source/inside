# Inside only for linux

1. Download and unzip the archive https://github.com/hepq-source/inside (or `git clone https://github.com/hepq-source/inside && cd inside`)
2. **Make sure that you have installed the packages `curl`, `iptables` and `ipset' (for FWTYPE=iptables) or `curl` and `nftables' (for FWTYPE=nftables)! If not, install it. If you don't know how, ask AI!**
3. Open the terminal in the folder where the archive was unpacked
4. `./install.sh `

# Management
## Systemd
Stop: `sudo systemctl stop inside`

Starting after stopping: `sudo systemctl start inside`

Disabling autorun (enabled by default): `sudo systemctl disable inside`

Enabling autorun: `sudo systemctl enable inside`
## OpenRC

Stop: `sudo rc-service inside stop`

Starting after stopping: `sudo rc-service inside start`

Enabling autorun: `sudo rc-update add inside`

Disabling autorun: `sudo rc-update del inside`
# Lists of domains
Is some blocked website not working? Try adding his domain to `/opt/inside/autohosts.txt `

Is an unblocked website not working? Add his domain to `/opt/inside/ignore.txt `

The configuration can be changed in `/opt/inside/config.txt ` (restart inside after the change)

The firewall type can be changed to `/opt/inside/system/FWTYPE` (restart inside after the change)

To check the current configuration, you can use `/opt/inside/check.sh `

# Variables in config.txt

`{hosts}` — sets the path to `autohosts.txt `

`{ignore}` — will substitute the path to `ignore.txt `

`{youtube}` — set the path to `youtube.txt `

`{quicgoogle}` — substitutes the path to `system/quic_initial_www_google_com.bin`

`{tlsgoogle}` — substitutes the path to `system/tls_clienthello_www_google_com.bin`
