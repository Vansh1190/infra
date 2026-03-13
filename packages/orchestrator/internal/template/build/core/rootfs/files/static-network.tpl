{{- /*gotype:github.com/e2b-dev/infra/packages/orchestrator/internal/template/build/core/rootfs.templateModel*/ -}}
{{ .WriteFile "etc/systemd/system/setup-network.service" 0o644 }}
[Unit]
Description=Configure network interface
Before=systemd-networkd.service network-pre.target
Wants=network-pre.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/sh -c 'ip link set dev eth0 up 2>/dev/null; for iface in /sys/class/net/e*; do DEV=$(basename $iface); ip addr add 169.254.0.21/30 dev $DEV 2>/dev/null; ip link set dev $DEV up 2>/dev/null; ip route add default via 169.254.0.22 dev $DEV 2>/dev/null; done'

[Install]
WantedBy=multi-user.target
