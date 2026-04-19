# AIC8800 Driver for Tenda AX300 USB Adapters

Out-of-tree Linux driver for Tenda USB adapters based on the AICSemi AIC8800DC chipset.

Supported devices:

| Device | USB ID | Chipset |
| --- | --- | --- |
| Tenda W311MI v6.0 | `2604:0013` | AIC8800DC |
| Tenda U2 v5.0 | `2604:0014` | AIC8800DC |

The USB IDs are registered in [drivers/aic8800/aic8800_fdrv/aicwf_usb.c](drivers/aic8800/aic8800_fdrv/aicwf_usb.c) and [drivers/aic8800/aic8800_fdrv/aicwf_usb.h](drivers/aic8800/aic8800_fdrv/aicwf_usb.h).

## Status

- Vendor driver, maintained here as an out-of-tree module.
- Firmware blobs are included in [`fw/aic8800DC/`](fw/aic8800DC).
- DKMS packaging is included for automatic rebuilds after kernel updates.
- The code has been brought into a usable state for local builds and packaging, but it has not been through a full security audit.

## Kernel support

- `6.8.x`: known build target
- `6.9.x` to `6.14.x`: expected to work, but treat as needing verification on your system
- `6.17+`: source-level compatibility work is present for relevant kernel API changes

The tree already contains version guards for newer cfg80211 and timer APIs. That still needs to be verified by building and loading the driver on the target kernel.

If you validate a new kernel release, update this README with the exact kernel version you tested.

## Requirements

You need kernel headers for the running kernel and a working build toolchain.

### Debian / Ubuntu

```bash
sudo apt install linux-headers-$(uname -r) build-essential
```

### Fedora

```bash
sudo dnf install @development-tools kernel-devel dkms
```

## Installation paths

There are two supported installation paths:

- manual build and install with `make`
- DKMS-based installation for automatic rebuilds after kernel updates

Use one or the other. Do not install both unless you know exactly which copy of the module you want to keep loaded.

## Repository layout

```text
aic8800/
├── dkms.conf
├── drivers/aic8800/
│   ├── aic_load_fw/
│   └── aic8800_fdrv/
├── fw/aic8800DC/
├── install_dkms.sh
├── install_setup.sh
├── uninstall_dkms.sh
├── uninstall_setup.sh
└── tools/aic.rules
```

## Quick start

From the repository root, build and install the modules:

```bash
cd aic8800/drivers/aic8800
make KDIR=/lib/modules/$(uname -r)/build
sudo make KDIR=/lib/modules/$(uname -r)/build install
sudo depmod -a
```

Install firmware and the udev rule:

```bash
cd aic8800
sudo ./install_setup.sh
```

Load the module:

```bash
sudo modprobe aic8800_fdrv
```

## DKMS installation

Use DKMS if you want the modules rebuilt automatically after kernel updates:

```bash
cd aic8800
sudo ./install_setup.sh
sudo ./install_dkms.sh
```

The DKMS package name is `aic8800-tenda` and the current package version is `6.4.3.0`.

The installer is safe to re-run for the same package version. It removes the existing DKMS registration for that version before adding it again.

To remove the DKMS package:

```bash
cd aic8800
sudo ./uninstall_dkms.sh
sudo ./uninstall_setup.sh
```

## Manual uninstall

If you installed the driver with `make install`, remove it with:

```bash
cd aic8800/drivers/aic8800
sudo make KDIR=/lib/modules/$(uname -r)/build uninstall
sudo depmod -a
cd ../../..
sudo ./uninstall_setup.sh
```

## Firmware and udev rule

`install_setup.sh` installs:

- firmware to `/lib/firmware/aic8800DC/`
- udev rule to `/etc/udev/rules.d/aic.rules`

`uninstall_setup.sh` removes both.

## Verifying the build

Check that the built module advertises the expected USB aliases:

```bash
modinfo aic8800/drivers/aic8800/aic8800_fdrv/aic8800_fdrv.ko | grep -E '2604.*0013|2604.*0014'
```

Useful runtime checks after a manual install:

```bash
lsmod | grep aic8800
dmesg | grep -i aic
```

If you installed through DKMS, confirm the package is registered:

```bash
dkms status | grep aic8800-tenda
```

## Troubleshooting

### Build fails

- Make sure the headers for `uname -r` are installed.
- Run `make clean` before switching to a different kernel build tree.
- If you are testing a newer kernel, inspect cfg80211 and timer API changes before assuming the driver is broken.

### Module builds but does not load

- Check Secure Boot first. Unsigned out-of-tree modules are commonly blocked.
- Review `dmesg` for firmware loading failures and USB probe errors.

### Firmware does not load

- Confirm that `/lib/firmware/aic8800DC/` exists after running `./install_setup.sh`.
- Confirm that the files from [`fw/aic8800DC/`](fw/aic8800DC) are present on the target system.

## Development notes

- Treat compatibility claims conservatively. "Builds in source form" and "works on hardware" are not the same claim.
- Do not mark a kernel as tested unless you have both built the module and loaded it successfully on that kernel.
- This is still vendor-style code. Prefer targeted fixes over broad rewrites.

## License

This repository is based on Tenda's vendor driver release. Review the upstream vendor sources and included notices before redistributing in another form.
