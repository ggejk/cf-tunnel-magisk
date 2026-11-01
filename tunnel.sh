#!/system/bin/sh
MODDIR=${0%/*}
TOKEN_FILE="$MODDIR/token.conf"
BIN="$MODDIR/cloudflared"
CHILD_PID_FILE=/data/local/tmp/wmx-cloudflared-child.pid

while true; do
  TOKEN=$(sed -n 's/^TUNNEL_TOKEN=//p' "$TOKEN_FILE" 2>/dev/null | head -n 1 | tr -d '\r')
  if [ -z "$TOKEN" ]; then
    log -t WMXCloudflared "Tunnel token is empty; retrying in 60 seconds"
    sleep 60
    continue
  fi

  log -t WMXCloudflared "Starting named Cloudflare Tunnel"
  "$BIN" tunnel --no-autoupdate run --token "$TOKEN" &
  child=$!
  echo "$child" > "$CHILD_PID_FILE"
  unset TOKEN
  wait "$child"
  rc=$?
  rm -f "$CHILD_PID_FILE"
  log -t WMXCloudflared "cloudflared exited with status $rc; retrying in 10 seconds"
  sleep 10
done
