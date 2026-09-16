#!/bin/bash
set -e

REPO="https://github.com/nima7145b/Duravex/archive/refs/heads/main.tar.gz"
TMP="/tmp/duravex-install"

echo "=== DURAVEX X-UI Installer ==="

export DEBIAN_FRONTEND=noninteractive
sed -i "s|http://ubuntu.mirror.afranet.com/ubuntu|http://archive.ubuntu.com/ubuntu|g" /etc/apt/sources.list

apt-get update
apt-get install -y curl tar nginx apache2 certbot python3-certbot-nginx

rm -rf "$TMP"
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

systemctl enable apache2
systemctl start apache2 || true

cat > /etc/nginx/sites-available/duravex <<'NGINX'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    location / {
        proxy_pass http://127.0.0.1:2053;
        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        proxy_read_timeout 300;
        proxy_send_timeout 300;
    }
}
NGINX

rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/duravex /etc/nginx/sites-enabled/duravex

nginx -t
systemctl enable nginx
systemctl restart nginx

rm -rf "$TMP"

echo
echo "===================================="
echo " DURAVEX X-UI installed successfully"
echo "===================================="
echo
echo "Panel: http://SERVER-IP/"
echo "Command: x-ui"
echo

systemctl --no-pager --full status x-ui
