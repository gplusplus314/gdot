#!/usr/bin/env bash

set -e

if [ "$(id -u)" -eq 0 ]; then
	echo "This script must NOT be run as root!" >&2
	exit 1
fi

# Exit early and do nothing if this isn't a known ASUS device that needs extra
# steps for hardware support.
if ! grep -q "ASUS" /sys/devices/virtual/dmi/id/sys_vendor; then
	echo "Not an Asus device; skipping Asus device-specific installations."
	exit 0
fi
if ! grep -q "ROG" /sys/devices/virtual/dmi/id/product_name; then
	echo "Not an Asus ROG device; skipping ROG device-specific installations."
	exit 0
fi

echo ""
echo ""
echo ""
echo "-----------------------------------------------------"
echo "Installing Asus device software"
echo "-----------------------------------------------------"
echo ""
echo ""
echo ""

sudo dnf copr enable -y lukenukem/asus-linux
sudo dnf update -y
sudo dnf install -y asusctl supergfxctl asusctl-rog-gui
sudo dnf update --refresh
sudo systemctl enable supergfxd.service

# Fix screen brightness adjustment:
sudo grubby --update-kernel=DEFAULT --args 'quiet splash nvidia-drm.modeset=1 i915.enable_dpcd_backlight=1 nvidia.NVreg_EnableBacklightHandler=0 nvidia.NVreg_RegistryDwords=EnableBrightnessControl=0'

## Install CachyOS Kernel
# NOTE: Won't need to install CachyOS Kernel once Fedora is on Linux kernel
# 6.19+. See here: https://www.phoronix.com/news/ASUS-Armoury-More-Hardware
echo "Installing CachyOS Kernel for Asus hardware support."
# Disable stock kernel updates:
sudo dnf config-manager setopt fedora.excludepkgs=kernel,kernel-core,kernel-modules,kernel-uki-virt,kernel-devel,kernel-modules-extra,kernel-modules-core,kernel-devel-matched
sudo dnf config-manager setopt updates.excludepkgs=kernel,kernel-core,kernel-modules,kernel-uki-virt,kernel-devel,kernel-modules-extra,kernel-modules-core,kernel-devel-matched
sudo dnf config-manager setopt updates-testing.excludepkgs=kernel,kernel-core,kernel-modules,kernel-uki-virt,kernel-devel,kernel-modules-extra,kernel-modules-core,kernel-devel-matched
# Add the CachyOS Kernel COPR
sudo dnf copr enable -y bieszczaders/kernel-cachyos

sudo dnf install -y kernel-cachyos kernel-cachyos-devel-matched
sudo dnf update

# Loop while the akmods service is active/running
echo "Waiting for kernel modules to rebuild..."
# Give systemd a moment to register the service start
sleep 3
# Wait while the service is "activating" (actually building)
while [ "$(systemctl show akmods.service -p SubState --value)" == "activating" ]; do
	echo -n "."
	sleep 2
done

# Check if it finished successfully
if systemctl is-failed --quiet akmods; then
	echo -e "\nError: Kernel modules failed to build. Check 'journalctl -u akmods'."
	exit 1
else
	echo -e "\nSuccess: All kernel modules are built."
fi
