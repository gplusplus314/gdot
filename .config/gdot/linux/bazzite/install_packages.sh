#!/bin/sh

set -e

if [ "$(id -u)" -eq 0 ]; then
	echo "This script must NOT be run as root!" >&2
	exit 1
fi

PACKAGES=""
addp() {
	PACKAGES="$PACKAGES $@"
}

## Flatpak GUI apps
addp "com.brave.Browser"          # Web browser
addp "com.github.tchx84.Flatseal" # Flatpak permissions management

flatpak install -y --noninteractive $PACKAGES

cd "$(dirname "$0")"
brew bundle --file=../common/Brewfile

## rpm-ostree layering
PACKAGES=""

# 1Password
curl https://downloads.1password.com/linux/keys/1password.asc |
	sudo tee /etc/pki/rpm-gpg/RPM-GPG-KEY-1password
cat <<'EOF' | sudo tee /etc/yum.repos.d/1password.repo
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-1password
EOF
addp 1password
addp 1password-cli

addp kitty # terminal

#####################
#                   #
# Specific laptops: #
#                   #
#####################
VENDOR=$(cat /sys/devices/virtual/dmi/id/sys_vendor)
PRODUCT_NAME=$(cat /sys/devices/virtual/dmi/id/product_name)
if [ "$VENDOR:$PRODUCT_NAME" == "ASUSTeK COMPUTER INC.:Asus Keyboard" ]; then
	cat <<'EOF' | sudo tee /etc/yum.repos.d/asus.repo
[copr:copr.fedorainfracloud.org:lukenukem:asus-linux]
name=Copr repo for asus-linux owned by lukenukem
baseurl=https://download.copr.fedorainfracloud.org/results/lukenukem/asus-linux/fedora-$releasever-$basearch/
type=rpm-md
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://download.copr.fedorainfracloud.org/results/lukenukem/asus-linux/pubkey.gpg
repo_gpgcheck=0
enabled=1
enabled_metadata=1
EOF
	addp "asusctl"
fi

rpm-ostree install $PACKAGES
