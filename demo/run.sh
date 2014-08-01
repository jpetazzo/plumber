#!/bin/sh
set -ex

[ -d /hostproc ]
[ -S /var/run/docker.sock ]
which docker >/dev/null

case "$1" in
	init)
		ip link add dev bridge type bridge
		ip link set dev bridge up
	;;
	add)
		NAME=$2
		IPADDR=$3
		CID=$(docker run -d --name $NAME placeholder)
		PID=$(docker inspect --format '{{.State.Pid}}' $CID)
		ip link add veth$PID type veth peer name vethg$PID
		ip link set dev veth$PID master bridge up
		[ -d /var/run/netns ] || mkdir /var/run/netns
		ln -s /hostproc/$PID/ns/net /var/run/netns/$PID
		ip link set dev vethg$PID netns $PID name eth1 up
		ip netns exec $PID ip addr add $IPADDR dev eth1
	;;
	*)
		echo "Unknown command: $1"
	;;
esac
