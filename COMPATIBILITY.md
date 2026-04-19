# Kernel Compatibility

## Supported Kernels

- 6.8.x (tested)
- 6.9.x - 6.14.x (expected to work)
- 6.17+ (source-level support included)

## Hardware

| Model | USB ID |
|-------|--------|
| W311MI v6.0 | 2604:0013 |
| U2 v5.0 | 2604:0014 |

These IDs are defined in `drivers/aic8800/aic8800_fdrv/aicwf_usb.c`.

## 6.17+ Support

Linux 6.17 introduced API changes in cfg80211 and timer functions. The driver handles this with conditional compilation:

```c
#if LINUX_VERSION_CODE >= KERNEL_VERSION(6, 17, 0)
    // new API
#else
    // old API
#endif
```

Changes include:
- `cfg80211_ops` callbacks updated (`change_beacon`, `set_wiphy_params`, etc.)
- Timer functions: `timer_delete_sync()` instead of `del_timer_sync()`, `timer_container_of()` instead of `from_timer()`
- `cfg80211_ch_switch_notify()` signature changes

To add support for newer kernels, check the kernel API in `include/net/cfg80211.h`.

## Building for New Kernels

If build fails on a new kernel version:

1. Check kernel API changes in `/usr/include/net/cfg80211.h`
2. Look for new function signatures in cfg80211_ops
3. Add version guards similar to existing ones
4. Test before claiming support