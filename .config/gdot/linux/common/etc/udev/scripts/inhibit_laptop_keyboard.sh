#!/bin/bash

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
# Exit early if the triggering device isn't a keyboard we've configured
for k in "${PRIMARY_KEYBOARDS[@]}"; do
	if [ "$k" == "$TRIGGERED_BY_DEVICE_NAME" ]; then
		break
	fi
	log "not primary keyboard"
	exit 0
done

# Exit early if arguments don't seem right
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
if [[ "$INHIBIT_VALUE" != "0" && "$INHIBIT_VALUE" != "1" ]]; then
	log "Error: \$2 must be '0' (not inhibited) or '1' (inhibited)."
	exit 1
fi

DRIVER_DIR=$(cat /tmp/inhibit_laptop_keyboard.driver_dir)
if [ -z "$DRIVER_DIR" ]; then
	# Identify the laptop's keyboard device
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

	DEVICE_ID=$(dirname "$DEVICE_PATH")
	DEVICE_ID=$(dirname "$DEVICE_ID")
	DEVICE_ID=$(basename "$DEVICE_ID")
	echo "$DEVICE_ID" >/tmp/inhibit_laptop_keyboard.device_id

	CURRENT_DIR="${DEVICE_PATH%/*}"
	DRIVER_DIR=""
	while [[ "$CURRENT_DIR" != "/sys" && "$CURRENT_DIR" != "." && "$CURRENT_DIR" != "" ]]; do
		POTENTIAL_DRIVER_DIR="$CURRENT_DIR/driver"
		if [[ -d "$POTENTIAL_DRIVER_DIR" ]] &&
			[[ -f "$POTENTIAL_DRIVER_DIR/bind" ]] &&
			[[ -f "$POTENTIAL_DRIVER_DIR/unbind" ]]; then

			DRIVER_DIR="$POTENTIAL_DRIVER_DIR"
			break
		fi
		CURRENT_DIR="${CURRENT_DIR%/*}"
	done
else
	DEVICE_ID=$(cat /tmp/inhibit_laptop_keyboard.device_id)
fi

case "$UDEV_ACTION" in
add)
	DRIVER_FILE="$DRIVER_DIR/unbind"
	;;
remove)
	DRIVER_FILE="$DRIVER_DIR/bind"
	;;
*)
	log "nope!"
	exit 0
	;;
esac

log "Driver file: $DRIVER_FILE"
log "device id: $DEVICE_ID"

echo "$DEVICE_ID" >"$DRIVER_FILE"

log "DONE!"
