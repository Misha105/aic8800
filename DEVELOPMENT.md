# Development Notes

## Building

```bash
cd drivers/aic8800
make clean          # remove build artifacts
make KDIR=/path/to/kernel/build
```

## Clean Build

Always run `make clean` before building for a different kernel.

## Firmware

Where the driver looks for firmware:
- Base path: `/lib/firmware/` or `/lib/firmware/aic8800DC/`
- The driver appends `/aic8800DC` to whatever path is configured

Install script handles the copy to `/lib/firmware/aic8800DC/`.

## DKMS

DKMS keeps the driver rebuilt after kernel updates.

dkms.conf location: `./dkms.conf` in project root.

Package details:
- Name: `aic8800-tenda`
- Version: `6.4.3.0`

## Before Claiming Support for a New Kernel

1. Clean: `make clean`
2. Build with new kernel headers
3. Check `modinfo` output has the right USB IDs
4. Try loading the module

Don't say "tested" unless you've actually built and loaded it.

## Adding Kernel Support

See COMPATIBILITY.md for how the version guards work.

## Code Style

This is a vendor drop. Feel free to clean up code style issues, but don't rewrite whole files unless necessary.

## Git

Build outputs go in `.gitignore`:

```
*.o
*.ko
*.mod.c
*.mod
*.order
.modules.order
.Module.symvers