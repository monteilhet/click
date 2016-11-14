
[Main](https://github.com/monteilhet/click)

# Difference between user and kernel mode

Click can be compiled as a user-level program or as a kernel module for Linux. Either driver can receive and send packets; the kernel module directly interacts with device drivers, while the user-level driver uses packet sockets (on Linux) or the pcap library (everywhere else).


## User level driver

http://read.cs.ucla.edu/click/docs/userdriver

The click driver (click executable) executes a Click modular router specification in a user-level program. For instance run the user-level program by giving it the name of a configuration file: `click CONFIGFILE`.

Then it reads the router configuration file, sets up the router according to that file, and generally continues until interrupted. The router configuration is written in the Click language.

The user-level driver uses packet sockets (on Linux) or the pcap library (everywhere else).
The click program can read and write packets from the network using Berkeley Packet Filters.
User-level `FromDevice` element behaves like a packet sniffer by default since each packet will get processed twice (once by Click, once by the kernel).



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

http://read.cs.ucla.edu/click/docs/linuxmodule

Click also can run inside a Linux kernel as a module.

The Click modular router can be compiled as a Linux kernel module, called _click.ko_. Kernel build also produces another kernel module _proclikefs.ko_ taking  charge of the Click filesystem.

To install a configuration and load the click kernel module it is required to use <code>click-install CONFIGFILE</code>.

The click-install executable installs the module if necessary, mounts the Click file system onto the /click directory, and installs a configuration.

The module's API is a filesystem similar to the proc filesystem. Click creates a number of files under /click, some read-only and some read/write. You control the module by writing to these files, which are called handlers.

NB click-install installs a router configuration by writing it to /click/config or /click/hotconfig.

The linux kernel driver can steal packets from network devices before Linux gets a chance to handle them, send packets directly to devices, and send packets to Linux for normal processing. Several element classes control how the module receives and transmits packets:
 + `FromDevice` and `PollDevice` steal packets from devices before Linux processes them,
 + `ToDevice` sends packets directly to devices, and `ToHost` sends packets to Linux for normal processing.

=> kernel configurations replace normal network processing !!!

At one time only one click configuration can be installed by the kernel driver. Installing a new configuration will just replace the current one !

Removing the module or installing a null configuration will restore your machine's default networking behavior.

<tt>elements/linuxmodule</tt> directory contains kernel driver specific elements :

Element | Category | Description
------- | -------- | -----------
[FromDevice](http://read.cs.ucla.edu/click/elements/fromdevice) | Network Devices | reads packets from network device (Linux kernel)
[PollDevice](http://read.cs.ucla.edu/click/elements/polldevice) | Network Devices | polls packets from network device (kernel)
[ToDevice](http://read.cs.ucla.edu/click/elements/todevice) | Network Devices | sends packets to network device (Linux kernel)
[FromHost](http://read.cs.ucla.edu/click/elements/fromhost) | Host and Socket Communication | reads packets from Linux
[ToHost](http://read.cs.ucla.edu/click/elements/tohost) | Host and Socket Communication | sends packets to Linux
[ToHostSniffers](http://read.cs.ucla.edu/click/elements/fromsocket) | Host and Socket Communication | sends packets to Linux packet sniffers


FromDevice PROMISC option : Boolean. If true, the device is put into promiscuous mode while FromDevice is active. Default is false.

The KernelHandlerProxy element used in a userlevel configuration allows to proxy kernel module handlers at user level.
Used in concjunction with ControlSocket element, it will allow other user-level programs to call read or write handlers on the router installed in kernel mode.


### Manual loading

click-install CONFIGFILE is equivalent to :

1. Load the proclikefs module with insmod : <code>/sbin/insmod /usr/local/lib/proclikefs.ko</code>
2. Load the click module with insmod: <code>/sbin/insmod /usr/local/lib/click.ko</code>
3. Mount the Click filesystem on a directory <tt>/click<tt> using mount. <code>mount -t click none /click</code>
   NB The Click kernel module installs a symbolic link from /proc/click to /click.
4. Install a configuration by writing it to /click/config: <code>cat CONFIGFILE > /click/config</code>, for example.

click-uninstall is equivalent to :

1. kill the current router by installing an empty configuration: <code>echo > /click/config </code>
2. rmmod the click module : <code>/sbin/rmmod click</code>
3. unmout click filessystem /click : <code>umount /click</code>

### Using Kernel configuration

The click-install command alllows to install a new configuration in kernel mode.

```bash
sudo click-install [options] [param=value ...] config.click
```

For instance to install the following configuration named a-dev-test.click :

```c
define($DEV eth1);
FromDevice($DEV) -> Print(in) -> Discard;
```

The command allows to specify parameters values to use in the configuration

```bash
$ sudo  click-install DEV=eth2 a-dev-test.click
```

To check that the corresponding click module is installed at kernel level, we can use :


```bash
$ sudo  lsmod | grep click
click                2474583  0
proclikefs             14638  4 click
```
When the router configuraiton is running in kernel mode, output messages are available in the syslog system file or using the dmesg command :

```bash
$ tail -f /var/log/syslog
```

## Handlers

In kernel mode as in user mode, it is possible to interact with a running router configuration through handlers.
Handlers are methods that can be called to retrieve and/or change values ​​at the router configuration or at each configuration item.

However the mode of interaction using handlers differs completely between the 2 modes.

Click in kernel mode uses entries in the Linux /proc filesystem in order to, among others, implement the elements' read and write handlers.

Click kernel handlers relies on a virtual file system <tt> /click </ tt> (similar to the proc filesystem) to communicate between user space and the Linux kernel. Click files in the file system <tt> / click </ tt> are in read/write mode and provide the means to communicate with the kernel entities.

When installing a new kernel configuration with click-install, it mounts the Click file system onto the /click directory. Click creates a number of files under /click (or wherever you have mounted the filesystem), some read-only and some read/write (writable by the superuser). You control the module by writing to these files, which are called handlers. Every element in the current router configuration has a directory under /click.


With the userlevel driver, you can interact with the running click configuration using handlers.
Handlers access is performed through a click controlsocket element. This element opens a control socket that allows other user-level programs to call read or write handlers on the router running at user level.



