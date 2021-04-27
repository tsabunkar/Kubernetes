# Permanently Assigning Static IpAddress to enp0s8 network interface (which is Host-only)
auto enp0s3
iface enp0s3 inet static
#Change this ipv4 addr different for each vm/nodes
      address 192.168.99.10 
      netmask 255.255.255.0