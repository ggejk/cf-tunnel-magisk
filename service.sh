#!/system/bin/sh
MODDIR=${0%/*}
LOG_FILE=/data/local/tmp/wmx-cloudflared.log

# Wait until Android has completed boot before opening network connections.
until [ "$(getprop sys.boot_completed)" = "1" ]; do
  sleep 2
done

if [ ! -x "$MODDIR/cloudflared" ]; then
  log -t WMXCloudflared "cloudflared binary missing or not executable"
  exit 0
fi

PID_FILE=/data/local/tmp/wmx-cloudflared-supervisor.pid
if [ -f "$PID_FILE" ]; then
  old_pid=$(cat "$PID_FILE" 2>/dev/null)
  if [ -n "$old_pid" ] && kill -0 "$old_pid" 2>/dev/null; then
    exit 0
  fi
fi

nohup "$MODDIR/tunnel.sh" >> "$LOG_FILE" 2>&1 </dev/null &
echo $! > "$PID_FILE"
log -t WMXCloudflared "supervisor started; log: $LOG_FILE"
