#!/bin/sh
set -e

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found at $CONFIG_FILE, generating dummy config..."
    cat <<EOF > "$CONFIG_FILE"
{
  "log": { "loglevel": "warning" },
  "inbounds": [{
    "port": 1080,
    "protocol": "socks",
    "settings": { "auth": "noauth" },
    "sniffing": { "enabled": true, "destOverride": ["http", "tls"] }
  }],
  "outbounds": [{ "protocol": "freedom", "settings": {} }]
}
EOF
fi

if [ "$1" = "v2ray" ]; then
    exec v2ray run -config "$CONFIG_FILE"
fi

exec "$@"