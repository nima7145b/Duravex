#!/bin/bash
set -e

REPO="https://github.com/nima7145b/Duravex.git"
TMP="/tmp/duravex-install"

rm -rf "$TMP"
git clone --depth 1 "$REPO" "$TMP"

rm -rf /usr/local/x-ui
mkdir -p /usr/local/x-ui
cp -a "$TMP/x-ui/." /usr/local/x-ui/
cp -f "$TMP/x-ui.service" /etc/systemd/system/x-ui.service

chmod +x /usr/local/x-ui/x-ui
chmod +x /usr/local/x-ui/x-ui.sh
chmod +x /usr/local/x-ui/x-ui.rc

systemctl daemon-reload
systemctl enable x-ui
systemctl restart x-ui

rm -rf "$TMP"

echo "DURAVEX X-UI installed successfully."
systemctl --no-pager --full status x-ui
