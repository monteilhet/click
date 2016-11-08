
# Difference between user and kernel mode

Click can be compiled as a user-level program or as a kernel module for Linux. Either driver can receive and send packets; the kernel module directly interacts with device drivers, while the user-level driver uses packet sockets (on Linux) or the pcap library (everywhere else).


## User level driver

The click driver (click executable) executes a Click modular router specification in a user-level program. For instance run the user-level program by giving it the name of a configuration file: click CONFIGFILE.

The click program can read and write packets from the network using Berkeley Packet Filters. User-level FromDevice behaves like a packet sniffer by default since each packet will get processed twice (once by Click, once by the kernel).

## Kernel driver

