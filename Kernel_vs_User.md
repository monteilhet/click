
[Main](Readme.md)

# Difference between user and kernel mode

Click can be compiled as a user-level program or as a kernel module for Linux. Either driver can receive and send packets; the kernel module directly interacts with device drivers, while the user-level driver uses packet sockets (on Linux) or the pcap library (everywhere else).


## User level driver

The click driver (click executable) executes a Click modular router specification in a user-level program. For instance run the user-level program by giving it the name of a configuration file: `click CONFIGFILE`.

The click program can read and write packets from the network using Berkeley Packet Filters. User-level `FromDevice` element behaves like a packet sniffer by default since each packet will get processed twice (once by Click, once by the kernel).

Within the user-level driver, `FromDevice` and `ToDevice` elements used are specific to this mode ( implementation of those elements are located in <tt>elements/userlevel</tt> )

<tt>elements/userlevel</tt> directory contains elements specific to userlevel driver :

Element | Category | Description
------- | -------- | -----------
[FromDevice](http://read.cs.ucla.edu/click/elements/fromdevice.u) | Network Devices | reads packets from network device (at user-level)
[ToDevice](http://read.cs.ucla.edu/click/elements/todevice.u) | Network Devices | sends packets to network device (at user-level)
[FromHost](http://read.cs.ucla.edu/click/elements/fromhost.u) | Host and Socket Communication | interface to /dev/net/tun or ethertap (user-level)
[ToHost](http://read.cs.ucla.edu/click/elements/tohost.u) | Host and Socket Communication | sends packets to Linux via Universal TUN/TAP device
[FromSocket](http://read.cs.ucla.edu/click/elements/fromsocket) | Host and Socket Communication | reads data from socket (user-level)
[ToSocket](http://read.cs.ucla.edu/click/elements/tosocket) | Host and Socket Communication | sends data to socket (user-level)
[KernelFilter](http://read.cs.ucla.edu/click/elements/kernelfilter) | Host and Socket Communication | block kernel from handling packets
[KernelTap](http://read.cs.ucla.edu/click/elements/kerneltap) | Host and Socket Communication | interface to /dev/tap or ethertap (user-level)
[KernelTun](http://read.cs.ucla.edu/click/elements/kerneltun) | Host and Socket Communication | interface to /dev/tun or ethertap (user-level)
[ControlSocket](http://read.cs.ucla.edu/click/elements/controlsocket) | Control | opens control sockets for other programs


The click userlevel driver can run a configuration including a `ControlSocket` element. `ControlSocket` element implement a server handling a relatively simple line-based protocol allowing remote client user-level programs to call read or write handlers on the router.

## Kernel driver

Click also can run inside a Linux kernel as a module.

The Click modular router can be compiled as a Linux kernel module, called click.ko.
To install a configuration and load the click kernel module it is required to use <code>click-install CONFIGFILE</code>.