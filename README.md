# WMX Cloudflare Tunnel

Root module for ARM64 Android on Magisk and KernelSU. It runs `cloudflared` as a named Tunnel and forwards a Cloudflare hostname to a local HTTP service at `127.0.0.1:3100`. Install the ZIP from the Magisk or KernelSU manager; custom recovery installation is not supported.

## Setup

1. In Cloudflare Zero Trust, create a remotely managed Tunnel and add a Public Hostname route to `http://localhost:3100`.
2. Protect the hostname with Cloudflare Access. Use a domain active in your Cloudflare account.
3. Install this module ZIP with Magisk or KernelSU Manager, then reboot. KernelSU extracts the module and runs `customize.sh` to restore executable permissions.
4. Set the Tunnel token on the device as root:

   ```sh
   adb shell su -c 'printf "TUNNEL_TOKEN=%s\\n" "YOUR_TOKEN" > /data/adb/modules/wmx_cf_tunnel/token.conf; chmod 600 /data/adb/modules/wmx_cf_tunnel/token.conf'
   ```

5. Reboot or use the module's Action button to start the Tunnel.

Keep the token secret. `token.conf` is excluded from this repository; do not add credentials to commits, ZIPs, screenshots, or logs.

## Diagnostics

```sh
adb shell su -c 'cat /data/local/tmp/wmx-cloudflared.log'
adb shell su -c 'logcat -d -s WMXCloudflared'
adb shell su -c 'ps -A | grep cloudflared'
```

The Tunnel retries after the `cloudflared` process exits. Android and network availability determine uptime. This module only forwards HTTP traffic; the service on port 3100 must be running and reachable from Android.
