#!/bin/sh

set -eux

USER=$(getent passwd 1000 | cut -d: -f1)

apt update
apt install -y sudo curl wget zip unzip rsync rclone git python3 python3-venv
sudo usermod -aG sudo $USER

curl -fsSL https://sing-box.app/gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/sagernet.gpg
echo "deb [arch=amd64] https://deb.sagernet.org * *" | sudo tee /etc/apt/sources.list.d/sagernet.list > /dev/null

sudo apt update
sudo apt install sing-box

sudo rm -f /etc/sing-box/*
curl -fsSL $PROXY_SUBSCRIPTION -H "User-Agent: sing-box" | sudo tee /etc/sing-box/remote.json > /dev/null
cat << EOF | sudo tee /etc/sing-box/web-ui.json > /dev/null
{
    "experimental": {
        "clash_api": {
            "external_controller": "127.0.0.1:9090",
            "external_ui": "dashboard"
        }
    }
}
EOF
cat << 'EOF' | sudo tee /etc/cron.hourly/update-proxy.sh > /dev/null
curl -fsSL $PROXY_SUBSCRIPTION -H "User-Agent: sing-box" > /tmp/tmpfile \
    && [ -s /tmp/tmpfile ] \
    && sudo mv /tmp/tmpfile /etc/sing-box/remote.json
EOF

sudo systemctl enable --now sing-box
sleep 10 && curl -I https://google.com --max-time 5

cd /etc/apt/trusted.gpg.d
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o microsoft.gpg
curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o google-chrome.gpg
curl -fsSL https://download.docker.com/linux/debian/gpg      | sudo gpg --dearmor -o docker.gpg

cd /etc/apt/sources.list.d
echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main"    | sudo tee vscode.list        > /dev/null
echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb stable main"       | sudo tee google-chrome.list > /dev/null
echo "deb [arch=amd64] https://download.docker.com/linux/debian bookworm stable" | sudo tee docker.list        > /dev/null

sudo apt update
sudo apt install -y code google-chrome-stable docker-ce
sudo usermod -aG docker $USER
