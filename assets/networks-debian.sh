# Permanently Assigning Static IpAddress to enp0s8 network interface (which is Host-only)
auto enp0s8
iface enp0s8 inet static
      address 192.168.99.10
      netmask 255.255.255.0