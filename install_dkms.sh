#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_NAME="aic8800-tenda"
PKG_VERSION="6.4.3.0"
DKMS_SRC_DIR="/usr/src/${PKG_NAME}-${PKG_VERSION}"

run_as_root() {
	if command -v sudo >/dev/null 2>&1; then
		sudo "$@"
	else
		su -c "$*"
	fi
}

run_as_root rm -rf "${DKMS_SRC_DIR}"
run_as_root mkdir -p /usr/src
run_as_root cp -r "${SCRIPT_DIR}" "${DKMS_SRC_DIR}"
run_as_root dkms add -m "${PKG_NAME}" -v "${PKG_VERSION}"
run_as_root dkms build -m "${PKG_NAME}" -v "${PKG_VERSION}"
run_as_root dkms install -m "${PKG_NAME}" -v "${PKG_VERSION}"
