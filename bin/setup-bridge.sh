#!/bin/sh

DEFAULT=$(ip route | grep default | cut -d " " -f 3)
IP=$(ip addr show eth0 | grep "inet[^6]" | cut -d " " -f 6)

ip addr del $IP dev eth0

brctl addbr qemu0
brctl addif qemu0 eth0

ip addr add $IP dev qemu0
ip link set qemu0 up

ip route add default via $DEFAULT

echo "allow qemu0" >> /etc/qemu/bridge.conf
