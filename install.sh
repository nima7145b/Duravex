#!/bin/bash
set -e

rm -rf /usr/local/x-ui
mkdir -p /usr/local/x-ui
cp -a "$(dirname "$0")/x-ui/." /usr/local/x-ui/

cp -f "$(dirname "$0")/x-ui.service" /etc/systemd/system/x-ui.service

chmod +x /usr/local/x-ui/x-ui
chmod +x /usr/local/x-ui/x-ui.sh
chmod +x /usr/local/x-ui/x-ui.rc

systemctl daemon-reload
systemctl enable x-ui
systemctl restart x-ui

echo "DURAVEX X-UI installed successfully."
systemctl --no-pager --full status x-ui
