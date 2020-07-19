YPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
#BOOTPROTO=dhcp
#Setting static ip addr -> 'none'
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=enp0s3
UUID=ca1f0acc-db91-323b-8027-b992c464a38e
DEVICE=enp0s3
ONBOOT=yes
AUTOCONNECT_PRIORITY=-999
# Permanently Assigning Static IpAddress to enp0s8 network interface (which is Host-only)
# Setting static ip addr to host-only adapter
DEVICE=enp0s8
ONBOOT=yes
IPADDR=192.168.99.12
PREFIX=24
GATEWAY=192.168.99.1

