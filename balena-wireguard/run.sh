#!/usr/bin/env bash

set -euo pipefail

cleanup() {
    test $? -eq 0 || wg-quick down wg0
    tail -f /dev/null
}

trap "cleanup" TERM INT QUIT EXIT

config_root=/etc/wireguard
#module_path=/usr/src/app/wireguard.ko
peer_template=/usr/src/app/templates/peer.conf

server_conf_path="${config_root}"/wg0.conf

# load required modules
echo "Loading udp_tunnel module..."
modprobe udp_tunnel

# load wireguard module and grep dmesg to logs
echo "Loading wireguard module..."
#modinfo "${module_path}"
#insmod "${module_path}" || true
#dmesg | grep wireguard

#mkdir -p "${config_root}"

# restrict default file creation permissions
#umask 077

# substitute env vars in peer template conf
echo "Exporting env vars ..."
export PEER_ADDRESS PEER_PRIVKEY PEER_DNS PEER_PUBKEY PEER_PREKEY SERVER_HOST SERVER_PORT ALLOWEDIPS
envsubst < "${peer_template}" > "${server_conf_path}"

#mkdir -p /dev/net
#TUNFILE=/dev/net/tun
#[ ! -c ${TUNFILE} ] && mknod ${TUNFILE} c 10 200

# set file permissions
chmod 600 "${config_root}"/*

echo "Bringing interface wg0 up..."
wg-quick up wg0

while : ; do
  sleep 120
done
