#!/bin/bash
set -euo pipefail

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

run_as_root dkms remove -m "${PKG_NAME}" -v "${PKG_VERSION}" --all || true
run_as_root rm -rf "${DKMS_SRC_DIR}"
