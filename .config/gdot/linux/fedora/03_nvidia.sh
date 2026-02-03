#!/usr/bin/env bash

set -e

if [ "$(id -u)" -eq 0 ]; then
	echo "This script must NOT be run as root!" >&2
	exit 1
fi

# If this machine doesn't have an Nvidia GPU, exit early and do nothing.
if ! lspci | grep -q "NVIDIA"; then
	echo "No NVIDIA GPU found; skipping NVIDIA driver installation."
	exit 0
fi

echo ""
echo ""
echo ""
echo "-----------------------------------------------------"
echo "Installing NVIDIA GPU drivers."
echo "-----------------------------------------------------"
echo ""
echo ""
echo ""

# Make sure the system is up to date before we continue
sudo dnf update -y

# Enable RPM Fusion (free and non-free) repositories
echo "Enabling RPM Fusion"
sudo dnf install -y \
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf update -y
sudo dnf install -y kernel-devel akmod-nvidia xorg-x11-drv-nvidia-cuda

# Loop until modinfo returns a version number instead of an error
echo "Waiting for akmod-nvidia to finish building the kernel module."
echo "This typically takes 3–5 minutes. Do NOT interrupt."
set +e
until modinfo -F version nvidia &>/dev/null; do
	printf "."
	sleep 2
done
set -e
echo -e "\nDone. NVIDIA kernel module is built and ready."
echo "Current Driver Version: $(modinfo -F version nvidia)"

echo "Enabling power management services..."
sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service nvidia-resume.service nvidia-powerd.service

echo "Setting Linux kernel command line parameters..."
# Define the parameters to add
PARAMS="rd.driver.blacklist=nouveau modprobe.blacklist=nouveau nvidia-drm.modeset=1"
# This regex looks for GRUB_CMDLINE_LINUX="... " and inserts the params before the closing quote
sudo sed -i "/^GRUB_CMDLINE_LINUX=/ s/\"$/ $PARAMS\"/" /etc/default/grub
# Clean up any potential double spaces created by the append
sudo sed -i 's/  */ /g' /etc/default/grub
# Update the GRUB configuration to apply changes
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

echo "Done. Nvidia drivers will be loaded upon reboot."
