# AIC8800 (Tenda AX300) Linux Driver

Out-of-tree Linux driver for Tenda AX300 Wi-Fi 6 USB adapters based on AICSemi AIC8800 chipset.

## Supported Hardware

| Model | USB ID | Chip |
|-------|--------|------|
| Tenda W311MI v6.0 | 2604:0013 | AIC8800DC |
| Tenda U2 v5.0 | 2604:0014 | AIC8800DC |

## Requirements

- Linux kernel 6.8+ (with headers)
- build-essential (Debian/Ubuntu) or @development-tools (Fedora)
- kernel-devel (Fedora)

### Ubuntu/Debian

```bash
sudo apt install linux-headers-$(uname -r) build-essential
```

### Fedora

```bash
sudo dnf install @development-tools kernel-devel
```

## Build

```bash
cd drivers/aic8800
make KDIR=/lib/modules/$(uname -r)/build
```

## Install

### Module installation

```bash
sudo make KDIR=/lib/modules/$(uname -r)/build install
sudo depmod -a
```

### Firmware and udev rules

```bash
cd ../..
sudo ./install_setup.sh
```

### Load driver

```bash
sudo modprobe aic8800_fdrv
```

## DKMS (automatic rebuild on kernel update)

```bash
# Install
sudo apt install dkms  # Debian/Ubuntu
sudo dnf install dkms    # Fedora
sudo ./install_setup.sh
sudo ./install_dkms.sh

# Remove
sudo ./uninstall_dkms.sh
sudo ./uninstall_setup.sh
```

## Uninstall

```bash
cd drivers/aic8800
sudo make KDIR=/lib/modules/$(uname -r)/build uninstall
sudo depmod -a
cd ..
sudo ./uninstall_setup.sh
```

## Verify

```bash
modinfo ./aic8800_fdrv/aic8800_fdrv.ko | grep -E '2604.*0013|2604.*0014'
```

## Secure Boot

If Secure Boot is enabled, the module won't load unless you sign it or disable Secure Boot in BIOS.

## Firmware

Firmware files are included in `fw/aic8800DC/`. The install script copies them to `/lib/firmware/aic8800DC/`.

## Kernel Compatibility

The driver supports kernels 6.8 through 6.17+ using conditional compilation.

Tested on:
- Ubuntu 6.8.x kernels
- Fedora 41 (6.9-6.14.x)

Source includes compatibility code for Linux 6.17+ API changes (cfg80211 callbacks, timer functions).

## Build Problems?

Common fixes:

1. **Missing headers**: Install linux-headers package matching your running kernel
2. **Permission denied**: Use sudo for install/uninstall commands
3. **Secure Boot**: Disable in BIOS or sign the module

## License

Based on Tenda's official driver release. See vendor for original license terms.

## Links

- [Tenda W311MI v6.0](https://www.tendacn.com/product/support/W311MIv6)
- [Tenda U2 v5.0](https://www.tendacn.com/product/support/U2V5)