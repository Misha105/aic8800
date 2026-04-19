#!/bin/bash
set -euo pipefail

if command -v sudo >/dev/null 2>&1; then
	AS_ROOT=(sudo)
else
	AS_ROOT=(su -c)
fi

run_as_root() {
	if [ "${AS_ROOT[0]}" = "sudo" ]; then
		sudo "$@"
	else
		su -c "$*"
	fi
}

echo "Removing AIC8800 firmware files and udev rule"
run_as_root rm -rf /lib/firmware/aic8800DC
run_as_root rm -f /etc/udev/rules.d/aic.rules
run_as_root udevadm control --reload
run_as_root udevadm trigger

echo "Uninstall completed"
