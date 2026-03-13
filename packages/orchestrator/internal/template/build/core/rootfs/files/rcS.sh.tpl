{{- /*gotype:github.com/e2b-dev/infra/packages/orchestrator/internal/template/build/core/rootfs.templateModel*/ -}}
{{ .WriteFile "etc/init.d/rcS" 0o777 }}

#!/usr/bin/busybox ash
echo "Mounting essential filesystems"
# Ensure necessary mount points exist
mkdir -p /proc /sys /dev /tmp /run

# Mount essential filesystems
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev
mount -t tmpfs tmpfs /tmp
mount -t tmpfs tmpfs /run

echo "Configuring network"
# The kernel ip= boot parameter requires CONFIG_IP_PNP=y.
# If the kernel lacks it (e.g. stock distro kernels), configure from userspace.
if ! ip addr show eth0 2>/dev/null | busybox grep -q "169.254.0.21"; then
    ip link set eth0 up
    ip addr add 169.254.0.21/30 dev eth0
    ip route add default via 169.254.0.22
    echo "Network configured from userspace (kernel IP_PNP not available)"
else
    echo "Network already configured by kernel"
fi

echo "System Init"