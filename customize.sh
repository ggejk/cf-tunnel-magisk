#!/system/bin/sh
# KernelSU applies default ownership; set executable and secret-file modes explicitly.
chmod 0755 "$MODPATH/cloudflared" "$MODPATH/service.sh" "$MODPATH/tunnel.sh" "$MODPATH/action.sh"
chmod 0600 "$MODPATH/token.conf"
