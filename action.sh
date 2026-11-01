#!/system/bin/sh
MODDIR=${0%/*}
LOG_FILE=/data/local/tmp/wmx-cloudflared.log
PID_FILE=/data/local/tmp/wmx-cloudflared-supervisor.pid

if [ -f "$PID_FILE" ]; then
  old_pid=$(cat "$PID_FILE" 2>/dev/null)
  case "$old_pid" in
    ''|*[!0-9]*) ;;
    *) kill "$old_pid" 2>/dev/null ;;
  esac
fi

nohup "$MODDIR/tunnel.sh" >> "$LOG_FILE" 2>&1 </dev/null &
echo $! > "$PID_FILE"
log -t WMXCloudflared "tunnel supervisor started/restarted"
