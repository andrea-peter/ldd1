Allow the BBB to access internet through the host via USB

Call `configure_all.sh` with the host's USB and Ethernet/Wifi interface names,
example:
```
./configure_all.sh enx168847f0f730 wlp2s0
```

To find the name of the interfaces:
```
ip address
```
The USB interface should have the IP address being either `192.168.6.1` or `192.168.7.1`
