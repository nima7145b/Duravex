#!/bin/bash
set -e

REPO="https://github.com/nima7145b/Duravex/archive/refs/heads/main.tar.gz"
TMP="/tmp/duravex-install"

echo "=== DURAVEX X-UI Installer ==="

export DEBIAN_FRONTEND=noninteractive


rm -rf "$TMP" /tmp/duravex.tar.gz
mkdir -p "$TMP"

curl -4L --progress-bar --connect-timeout 15 --max-time 300 "$REPO" -o /tmp/duravex.tar.gz
tar -xzf /tmp/duravex.tar.gz -C "$TMP" --strip-components=1

rm -rf /usr/local/x-ui
mkdir -p /usr/local/x-ui

cp -a "$TMP/x-ui/." /usr/local/x-ui/
cp -f "$TMP/x-ui.service" /etc/systemd/system/x-ui.service

chmod +x /usr/local/x-ui/x-ui
chmod +x /usr/local/x-ui/x-ui.sh
chmod +x /usr/local/x-ui/x-ui.rc

ln -sf /usr/local/x-ui/x-ui.sh /usr/local/bin/x-ui

systemctl daemon-reload
systemctl enable x-ui
systemctl restart x-ui

rm -rf "$TMP" /tmp/duravex.tar.gz

echo
echo "===================================="
echo " DURAVEX X-UI installed successfully"
echo "===================================="
echo
echo "Panel: http://SERVER-IP:2053/"
echo "Command: x-ui"
echo

systemctl --no-pager --full status x-ui
