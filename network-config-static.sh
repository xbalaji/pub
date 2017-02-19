#!/bin/bash

IFACE_2REPLACE="eth0"

iface_d="iface ${IFACE_2REPLACE} inet dhcp"
iface_s="iface ${IFACE_2REPLACE} inet static"

ip_line=$(ifconfig ${IFACE_2REPLACE} | grep 'inet addr')
a_line=$(echo $ip_line | awk '{print $2}' | sed -e 's/addr:/    address /')
m_line=$(echo $ip_line | awk '{print $4}' | sed -e 's/Mask:/    netmask /')
b_line=$(echo $ip_line | awk '{print $3}' | sed -e 's/Bcast:/    broadcast /')
g_line=$(route -n | grep '^0' | awk '{print $2}' | sed -e 's/^/    gateway /')

dns_servers=$(grep nameserver /etc/resolv.conf | awk '{printf "%s ", $2}')
d_line=$(echo "    dns-nameservers $dns_servers")
static_line="\n$iface_s\n$a_line\n$m_line\n$b_line\n$g_line\n$d_line\n"

sed -i -e "s,$iface_d,${static_line},g" /etc/network/interfaces
