#!/bin/bash

# How should we restrict upload/download bw.
rate_mbit=1000
shaped_iface="enp0s3"
ifb_iface="ifb0"

action=$1

function destroy {
   tc qdisc del dev ${shaped_iface} ingress
   tc qdisc del dev ${ifb_iface} handle 1: root
   tc filter del dev ${shaped_iface} egress
   tc qdisc del dev ${shaped_iface} handle 1: root
}

function create {
   tc qdisc add dev ${shaped_iface} handle ffff: ingress

   tc qdisc add dev ${ifb_iface} handle 1: root htb default 11
   tc class add dev ${ifb_iface} parent 1: classid 1:1 htb rate ${rate_mbit}mbit ceil ${rate_mbit}mbit
   tc class add dev ${ifb_iface} parent 1:1 classid 1:11 htb rate ${rate_mbit}mbit ceil ${rate_mbit}mbit


   tc qdisc add dev ${shaped_iface} handle 1: root htb default 11
   tc class add dev ${shaped_iface} parent 1: classid 1:1 htb rate ${rate_mbit}mbit ceil ${rate_mbit}mbit
   tc class add dev ${shaped_iface} parent 1:1 classid 1:11 htb rate ${rate_mbit}mbit ceil ${rate_mbit}mbit

   tc filter add dev ${shaped_iface} parent ffff: protocol ip u32 match u32 0 0 flowid 1:1 action mirred egress redirect dev ${ifb_iface}
}

function verify_up {
  ip_addr_up=`ip link show dev ${ifb_iface} up 2>&1 | wc -l`
  if [ ${ip_addr_up} -eq 0 ]; then
    echo "${ifb_iface} is not online!"
    exit 1
  fi
}

verify_up;

if [ "${action}" = "create" ]; then
   echo "Creating a rate-setting configuration."
   destroy;
   create;
elif [ "${action}" = "destroy" ]; then
   echo "Destroying rate-setting configuration."
   destroy;
else
   echo "Invalid action given: ${action} -- only create and destroy are valid."
fi

