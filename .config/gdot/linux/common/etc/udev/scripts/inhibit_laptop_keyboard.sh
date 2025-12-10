#!/bin/bash

# This script isn't ready and is a WIP.
exit 0

log() {
	echo $@ >>/tmp/inhibit_laptop_keyboard.log
}

TRIGGERED_BY_DEVICE_NAME="$1"
UDEV_ACTION="$2"

log "device that triggered: $TRIGGERED_BY_DEVICE_NAME"
log "action: $UDEV_ACTION"

# These keyboards should disable the laptop's internal keyboard:
PRIMARY_KEYBOARDS=(
	"ZMK Project vibraphone Keyboard"
	# Add more keyboard names here. Get the name from /proc/bus/input/devices
)
for k in "${PRIMARY_KEYBOARDS[@]}"; do
	if [ "$k" == "$TRIGGERED_BY_DEVICE_NAME" ]; then
		break
	fi
	log "not primary keyboard"
	exit 0
done

if [ -z "$TRIGGERED_BY_DEVICE_NAME" ]; then
	log "Error: \$1 must be the name of the device that triggered this script."
	exit 1
fi
case "$UDEV_ACTION" in
add)
	INHIBIT_VALUE="1"
	;;
remove)
	INHIBIT_VALUE="0"
	;;
*)
	exit 0
	;;
esac

LAPTOP_KEYBOARD_NAME="AT Translated Set 2 keyboard" # generic laptops
#####################
#                   #
# Specific laptops: #
#                   #
#####################
VENDOR=$(cat /sys/devices/virtual/dmi/id/sys_vendor)
PRODUCT_NAME=$(cat /sys/devices/virtual/dmi/id/product_name)
case "$VENDOR" in
"ASUSTeK COMPUTER INC.")
	case "$PRODUCT_NAME" in
	"ROG Zephyrus"*)
		LAPTOP_KEYBOARD_NAME="Asus Keyboard"
		;;
	esac
	;;
esac

# Identify the laptop's keyboard device
#
# /proc/bus/input/devices looks like many these, separated by blank lines:
#
# I: Bus=0019 Vendor=0000 Product=0003 Version=0000
# N: Name="Sleep Button"
# P: Phys=PNP0C0E/button/input0
# S: Sysfs=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
# U: Uniq=
# H: Handlers=kbd event0
# B: PROP=0
# B: EV=3
# B: KEY=4000 0 0
DEVICE_PATH=$(
	cat /proc/bus/input/devices |
		grep -A15 "N: Name=\"$LAPTOP_KEYBOARD_NAME\"" |
		grep "S: Sysfs="
)
DEVICE_PATH=${DEVICE_PATH#"S: Sysfs="}
if [ -z "$DEVICE_PATH" ]; then
	log "Error: Could not find a device with the name:" \
		"'$LAPTOP_KEYBOARD_NAME' in /proc/bus/input/devices."
	exit 1
fi
DEVICE_PATH="/sys/$DEVICE_PATH"

INHIBITED_FILE="$DEVICE_PATH/inhibited"

if [ ! -f "$INHIBITED_FILE" ]; then
	log "inhibited file $INHIBITED_FILE does not exist!"
	exit 1
fi

echo "$INHIBIT_VALUE" >"$INHIBITED_FILE"

log "DONE!"
