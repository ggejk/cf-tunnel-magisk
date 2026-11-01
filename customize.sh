#!/system/bin/sh
# KernelSU and Magisk source this script after extracting module files.

[ "${ARCH:-arm64}" = "arm64" ] || abort "This module requires an ARM64 device."
[ "${KSU:-false}" != "true" ] || ui_print "Installing for KernelSU ${KSU_VER:-}"

chmod 0755 "$MODPATH/cloudflared" "$MODPATH/service.sh" "$MODPATH/tunnel.sh" "$MODPATH/action.sh" || abort "Failed to set module executable permissions."
[ ! -f "$MODPATH/token.conf" ] || chmod 0600 "$MODPATH/token.conf" || abort "Failed to secure token.conf."
