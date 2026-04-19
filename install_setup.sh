#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FW_SRC="${SCRIPT_DIR}/fw/aic8800DC"
RULES_SRC="${SCRIPT_DIR}/tools/aic.rules"

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

echo "##################################################"
echo "AIC Wi-Fi driver setup"
echo "##################################################"

echo "Installing firmware and udev rule into system locations"
run_as_root install -d /lib/firmware
run_as_root rm -rf /lib/firmware/aic8800DC
run_as_root cp -r "${FW_SRC}" /lib/firmware/
run_as_root install -m 0644 "${RULES_SRC}" /etc/udev/rules.d/aic.rules
run_as_root udevadm control --reload
run_as_root udevadm trigger

if [ -L /dev/aicudisk ]; then
	run_as_root eject /dev/aicudisk
fi

echo "##################################################"
echo "Setup completed"
echo "##################################################"
