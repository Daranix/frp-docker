if [ $MODE -eq "client" ]; then
    exec /frp/frpc "$@"
else
    exec /frp/frps "$@"
fi