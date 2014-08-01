#!/bin/sh
set -ex

[ -d /hostproc ]
[ -S /var/run/docker.sock ]
which docker >/dev/null

N1=$1
IP1=$2
N2=$3
IP2=$4

ip link add dev bridge type bridge
ip link set dev bridge up
ip link add dev veth1a type veth peer name veth1b
ip link add dev veth2a type veth peer name veth2b
ip link set dev veth1a master bridge up
ip link set dev veth2a master bridge up

CID1=$(docker run -id --name $N1 busybox sh)
CID2=$(docker run -id --name $N2 busybox sh)
PID1=$(docker inspect --format '{{.State.Pid}}' $CID1)
PID2=$(docker inspect --format '{{.State.Pid}}' $CID2)

mkdir /var/run/netns
ln -s /hostproc/$PID1/ns/net /var/run/netns/x1
ln -s /hostproc/$PID2/ns/net /var/run/netns/x2

ip link set dev veth1b netns x1 name eth1 up
ip link set dev veth2b netns x2 name eth1 up

ip netns exec x1 ip addr add $IP1 dev eth1
ip netns exec x2 ip addr add $IP2 dev eth1

echo OK
echo Setup complete. Press ENTER to exit.
read junk


