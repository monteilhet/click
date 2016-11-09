// test-device-block.click

// Tests whether Click can read packets from the network.
// You may need to modify the device name in FromDevice.
// You'll probably need to be root to run this.


// Run with
// click [DEV=ethx] testdevice.click
// (runs as a user-level program; uses Linux packet sockets or a similar
// mechanism)

define($DEV eth1);
Message("Block traffic on $DEV");
// Message("use config DEV = $DEV");

KernelFilter(drop dev $DEV)
// or use FromDevice option SNIFFER false <=> KernelFilter(drop dev $DEV)
FromDevice($DEV) -> Print(in) -> Discard;

ControlSocket(tcp,5555);