#!/bin/sh

set -eux

cat << EOF > ~/.gitconfig
[user]
    name = nia
    email = mangrove0720@outlook.com

[core]
    editor = code --wait

[init]
    defaultBranch = main

[push]
    default = current

[alias]
    co = checkout
    br = branch
    cm = commit -m
    ca = commit --amend
EOF

mkdir -p ~/.ssh
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""

curl -fsSL https://github.com/boobam22/github-api/releases/download/v1.0.0/github-api.pyz > ~/.local/bin/github-api
chmod u+x ~/.local/bin/github-api
github-api ssh create -t "$(hostname)" -k "$(cat ~/.ssh/id_ed25519.pub)"

curl -fsSL https://pdm-project.org/install-pdm.py | python3 -
pdm python install 3.12

cd ~/.local/share

mkdir -p go
curl -fsSL https://go.dev/dl/go1.24.3.linux-amd64.tar.gz | tar -xz -C go
mv go/go go/1.24.3
ln -s ./1.24.3 go/default
echo 'export PATH="$HOME/.local/share/go/default/bin:$PATH"' >> ~/.bashrc

mkdir -p node
curl -fsSL https://nodejs.org/dist/v22.15.0/node-v22.15.0-linux-x64.tar.gz | tar -xz -C node
mv node/node-v22.15.0-linux-x64 node/22.15.0
ln -s ./22.15.0 node/default
echo 'export PATH="$HOME/.local/share/node/default/bin:$PATH"' >> ~/.bashrc

mkdir -p jdk
curl -fsSL https://download.oracle.com/java/21/archive/jdk-21.0.6_linux-x64_bin.tar.gz | tar -xz -C jdk
mv jdk/jdk-21.0.6 jdk/21.0.6
ln -s ./21.0.6 jdk/default
echo 'export PATH="$HOME/.local/share/jdk/default/bin:$PATH"' >> ~/.bashrc
