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

// OUTBOUND true => send effectively on todevice
// NB duplicates packet if OUTBOUND true and SNIFFER is true
// METHOD PCAP ?
// SNIFFER false <=> KernelFilter(drop dev $DEV)

// NOK packet arrives in and outbound is ignored
FromDevice($DEV, SNIFFER true, OUTBOUND false) -> Print(in)  -> Queue -> ToDevice($DEV, DEBUG true);

// Here to loop with SNIFFER False => need to build a ping response

// Test send packet on a different interface for instance to chain box => PROMISC FALSE