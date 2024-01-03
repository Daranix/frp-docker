#!/bin/sh
echo "Starting mode $MODE"
if [ $MODE = "client" ]; then
    exec /frp/frpc "$@"
else
    exec /frp/frps "$@"
fi