#!/system/bin/sh
# KernelSU and Magisk source this script after extracting module files.

[ "${ARCH:-arm64}" = "arm64" ] || abort "This module requires an ARM64 device."
[ "${KSU:-false}" != "true" ] || ui_print "Installing for KernelSU ${KSU_VER:-}"

if [ "${KSU:-false}" = "true" ] && [ "${KSU_HAS_HOT_INSTALL:-false}" = "true" ]; then
  export MODULE_HOT_INSTALL_REQUEST=true
  export MODULE_HOT_RUN_SCRIPT=action.sh
fi

# Keep the device-only secret when updating from an installed module.
if [ ! -f "$MODPATH/token.conf" ] && [ -f /data/adb/modules/wmx_cf_tunnel/token.conf ]; then
  cp /data/adb/modules/wmx_cf_tunnel/token.conf "$MODPATH/token.conf" || abort "Failed to preserve token.conf."
fi

chmod 0755 "$MODPATH/cloudflared" "$MODPATH/service.sh" "$MODPATH/tunnel.sh" "$MODPATH/action.sh" || abort "Failed to set module executable permissions."
[ ! -f "$MODPATH/token.conf" ] || chmod 0600 "$MODPATH/token.conf" || abort "Failed to secure token.conf."
