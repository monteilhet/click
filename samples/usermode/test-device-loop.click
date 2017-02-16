// test-device-loop.click

// Tests whether Click can read packets from the network.
// You may need to modify the device name in FromDevice.
// You'll probably need to be root to run this.


// Run with
// click [DEV=ethx] testdevice.click
// (runs as a user-level program; uses Linux packet sockets or a similar
// mechanism)

define($DEV eth1);
Message("Handle traffic on $DEV");

// OUTBOUND true => send effectively on todevice (<=> reentrant)
// NB if OUTBOUND true and SNIFFER is true => duplicates packet because the icmp request is reinjected in kernel and handled twice
// METHOD PCAP ?
// SNIFFER false <=> KernelFilter(drop dev $DEV)

// NOK packet arrives in and outbound is ignored 
FromDevice($DEV, SNIFFER true, OUTBOUND false) -> Print(in)  -> Queue -> ToDevice($DEV, DEBUG true);

// Here to loop with SNIFFER False => need to build a ping response and handle ARP for instance cf test-arp-ping
// In user mode ToHost element is not available to reinject packet in the stack of an existing interface (ToHost works only for tun/tap interfaces in userlevel mode)

// Todo: Test send packet on a different interface for instance to chain box => PROMISC TRUE