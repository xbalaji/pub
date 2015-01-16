#!/bin/bash

iface_d='iface eth0 inet dhcp'
iface_s='iface eth0 inet static'

ip_line=$(ifconfig eth0 | grep 'inet addr')
a_line=$(echo $ip_line | awk '{print $2}' | sed -e 's/addr:/   address /')
m_line=$(echo $ip_line | awk '{print $4}' | sed -e 's/Mask:/   netmask /')
b_line=$(echo $ip_line | awk '{print $3}' | sed -e 's/Bcast:/   broadcast /')
g_line=$(route -n | grep '^0' | awk '{print $2}' | sed -e 's/^/   gateway /')

dns_servers=$(grep nameserver /etc/resolv.conf | awk '{printf "%s ", $2}')
d_line=$(echo "   dns-nameservers $dns_servers")
static_line="\n$iface_s\n$a_line\n$m_line\n$b_line\n$g_line\n$d_line\n"

sed -i -e "s,$iface_d,${static_line},g" /etc/network/interfaces

