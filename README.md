
# Click router

## Quick description

### Background

Most routers have closed, static, and inflexible designs.

It is difficult for network administrators and third party software vendors to extend a router with new functions.

Click is a flexible, modular software architecture for creating routers.

Click routers are built from fine-grained components.
The components are packet processing modules called elements.


### Description

Click is a modular router toolkit.

Click is a software architecture for building configurable routers.

By using different combinations of packet processing units called _elements_, a Click router can be made to perform a specific kind of functionality (.e.g NAT proxy, firewall etc...).

Click is a modular software architecture enabling setup of a software router. A click router is built from elementary components called elements that constitute unit for packets processing.
The basic unit of communication between elements is the Packet.
Each element holds one or more input/output ports.

A click router configuration is an oriented graph of element where:

* vertices: processing applied to a packet
* edges: connections between ports and elements

To build a router configuration, the user chooses a collection of elements and connects them into a directed graph.

The router configuration is written in the Click language.

To extend a configuration, the user can write new elements or compose existing elements in new ways.


### Layered Moded in Click

"With great power comes great responsibility."
 * Click receives raw ethernet frames from Layer 2 and handles all the processing up until it is handed to the higher layers.
 * Click can also handle Transport layer headers such as intercepting UDP and TCP packets making it possible to implement daemons inside Click.
 * The user is in charge of respecting the layered model, not Click.


## References

* web site: http://read.cs.ucla.edu/click/click
* git repository: https://github.com/kohler/click/
* Docs :
    * PhD : https://pdos.csail.mit.edu/papers/click:kohler-phd/thesis.pdf
    * Documentation related to user mode and kernel mode and about tools: http://read.cs.ucla.edu/click/docs
    * List of Click available elements: http://read.cs.ucla.edu/click/elements


## Click software

Click can be compiled as a user-level program or as a kernel module for Linux

### User-Level Program

User-Level Program: the user-level driver uses packet sockets (on Linux) or the pcap library (everywhere else).
Run the user-level program by giving it the name of a configuration

http://read.cs.ucla.edu/click/docs/userdriver

```bash
click CONFIGFILE [ -p port]
```

### Kernel driver

The Click modular router can be compiled as a Linux kernel module, called click.ko. To install a configuration and load the click kernel module it is required to use :

```bash
click-install CONFIGFILE
```

NB The click-install executable installs the module if necessary, mounts the Click file system onto the /click directory, and installs a configuration (NB  click-install installs a router configuration by writing it to /click/config or /click/hotconfig).

The linux kernel driver can steal packets from network devices before Linux gets a chance to handle them, send packets directly to devices, and send packets to Linux for normal processing.

**WARNING** : The Linux kernel module is known to run (but not necessarily route packets) in kernel versions 2.6.24, 2.6.32, 3.0, 3.2, and 3.5. It should run on intermediate versions as well. *compilation will fail with linux kernek 4.x*

**WARNING2** : Click linux kernel has been successfully built using ubuntu server 14.04.1 with a kernel 3.13
NB since click commit c91fc67e3db click no more compile on ubuntu !


## Click installation

### Click sources

Git repository : https://github.com/kohler/click/ includes sources from click project with the following structure:

Git repository structure:
```
 .
 |-- conf                // various Click configuration files
 |-- drivers             // drivers with Click extensions (for polling)
 |-- elements            // the actual Click elements
 |-- etc                 // patch and other miscellaneous files
 |-- include
 |   |-- click           // base Click header files
 |-- lib                 // base Click cpp files
 |-- linuxmodule         // Click linux kernel mode files
 `-- userlevel           // Click user level files
```

### Build


```bash
$ sudo apt-get update
$ sudo apt-get -y install git gcc g++ make
$ git clone https://github.com/kohler/click.git
$ cd click

$ ### to display config options
$./configure --help

$ ### config to build click for user mode only
$ ./configure --enable-ip6 --disable-linuxmodule

$ ### config to build click for user & kernel mode using all available click elements
$ sudo ./configure --enable-all-elements

$ sudo make install

$ ### click binaries are installed in /usr/local/bin/
$ find /usr/local/bin/ -name "click*"

### Display version of installed click
$ click -v

### List click tools available for kernel driver
$ find /usr/local/sbin/ -name "click*"

```

## Using Click

### Click Test

Click configurations for test : In the conf directory of the click git repo there is a set of configuration files see http://read.cs.ucla.edu/click/examples

#### userlevel driver

For instance, you can run the following to test a basic click configuration running at userlevel

```bash
$ click ~/click/conf/test.click
```

NB : To run a click configuration using a system device (e.g FromDevice(eth0)), it is required to run the command with sufficient privileges (i.e. with root privileges)

```bash
$ sudo click ~/click/conf/delay.click
```

#### kernel driver

For instance, you can run the following to test a basic click configuration running in **kernel mode**

```bash
$ sudo click-install ~/click/conf/testdevice.click
```

The configuration installed in kernel is visible in the <tt>/click</tt> directory

The command <code>click-uninstall</code> unload the click module and remove the current configuration (the <tt>/click</tt> directory it then empty).

```bash
$ sudo click-uninstall
```


## Click documentation

All Click documentation is also available directly at the system level

```bash
man click : display manual page about click userlevel driver
man 8 click.o : display manual page about click kernel driver
man 5 click : display manual page about click language
man Print ControlSocket  : display manual page about some click elements

```

NB This documentation is also online

+ http://read.cs.ucla.edu/click/docs/userdriver
+ http://read.cs.ucla.edu/click/docs/linuxmodule
+ http://read.cs.ucla.edu/click/docs/language
+ http://read.cs.ucla.edu/click/elements/print
+ http://read.cs.ucla.edu/click/elements/controlsocket



## GUI Tool : Clicky

Clicky is a Click GUI using the GTK+ toolkit : http://read.cs.ucla.edu/click/clicky

Clicky can show Click configurations as text (with syntax highlighting) or diagrams, and can read and write handlers in live configurations. It can also generate output diagrams in PDF format.

### Installation

```bash
$  cd ~/click/apps/clicky
$  sudo apt-get -y install autoconf libgtk2.0-dev graphviz
$  autoreconf -i
$  ./configure
$  sudo make install
```

### Using Clicky


You can run the following to test clicky:

```bash
$ clicky -r click/conf/test-clicky.click &
```

To run a click configuration using system ressource (as network interface ethx e.g FromDevice(eth0)) you need to run the command with root privileges =>
```bash
$  sudo clicky -r ~/click/conf/delay.click
```

Clicky GUI can show Click configurations as text (View configuration menu) and/or diagrams (View Diagram menu).

In the view menu, it's also possible to choose to display additional sidebars  :
* List : left sidebar showing the list of all elements included in the configuration
* Element : right sidebar showing details of the currently selected element in the diagram view or in the list sidebar.

The toolbar allows to control the click engine (start, stop, restart).

The Configuration/Check for Errors menu allows to syntactically check the current configuration.

It is also possible to use clicky to display kernel driver configuration currently installed (using -k option)

```bash
$ clicky -k &
```

Clicky options:
 * -r option : open the specified click configuration with clicky and run userlevel click engine with it
 * -f option  : open the specified click configuration with clicky (show the configuration graph) without running it.
 * -k : Read configuration from kernel.

##  click concepts

click router : Extensible toolkit for writing packet processors

Architecture centered on elements
 * Small building blocks
 * Perform simple operations e.g. decrease TTL

Click routers : Directed graphs of elements

+ Router: Elements connected by edges
+ Output ports to input ports
+ Describes possible packet flows

Ports:
 * Push port: Source initiates packet transfer: event based packet flow
 * Pull port: Destination initiates packet transfer (Used with polling, scheduling,...)
 * Agnostic port: Becomes push or pull

Compound elements:
 * Group elements in larger elements


Elements (actually element classes): C++ classes
Element instantations: C++ objects
Click router configurations (or short Click routers): text files parsed when starting Click, Click builds object graph of elements

Handlers:
 * Like function calls to an element
 * ReadHandler: request a value from an element
 * WriteHandler: pass a string to an element
   NB (There is no ReadWriteHandler: you can’t call a ReadHandler with arguments)
 * Can be called from other elements or through socket

