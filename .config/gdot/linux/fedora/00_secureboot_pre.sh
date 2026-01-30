#!/usr/bin/env bash

## Secure Boot
echo "Setting up Secure Boot..."
sudo dnf install -y kmodtool akmods mokutil openssl
echo "You will need to enter a password now. You need to remember it so it can"
echo "be typed again into your BIOS when you reboot to enroll the key. It can"
echo 'be a simple password, such as "fedora".'
sudo kmodgenca -a --force
sudo mokutil --import /etc/pki/akmods/certs/public_key.der

echo ""
echo ""
echo ""
echo "#######################################################################"
echo "## !!! Attention !!!"
echo "#######################################################################"
echo ""
echo "You will now need to reboot to finish the Secure Boot setup. On the next"
echo "boot, MOK Management is launched (system BIOS, blue screen) and you"
echo "should choose to enroll the key. You will be asked for the password from"
echo "the previous step."
echo ""
echo "When you come back from the reboot, do this:"
echo "  ./gdot_continue.sh"

cat >"$HOME/gdot_continue.sh" <<EOF
#!/usr/bin/env bash
cd $HOME/.config/gdot/linux/fedora
./01_secureboot_post.sh
EOF
chmod +x "$HOME/gdot_continue.sh"
