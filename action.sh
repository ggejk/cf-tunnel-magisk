#!/system/bin/sh
MODDIR=${0%/*}
LOG_FILE=/data/local/tmp/wmx-cloudflared.log
PID_DIR=/data/local/tmp

for name in supervisor child; do
  pid_file="$PID_DIR/wmx-cloudflared-$name.pid"
  if [ -f "$pid_file" ]; then
    pid=$(cat "$pid_file" 2>/dev/null)
    case "$pid" in
      ''|*[!0-9]*) ;;
      *) kill "$pid" 2>/dev/null ;;
    esac
    rm -f "$pid_file"
  fi
done

nohup "$MODDIR/tunnel.sh" >> "$LOG_FILE" 2>&1 </dev/null &
echo $! > "$PID_DIR/wmx-cloudflared-supervisor.pid"
log -t WMXCloudflared "tunnel supervisor started/restarted"
