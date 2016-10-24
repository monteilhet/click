// test-device-block.click

// Tests whether Click can read packets from the network.
// You may need to modify the device name in FromDevice.
// You'll probably need to be root to run this.

// Run with
// click-install [DEV=ethx] testdevice.click
// (runs inside a Linux kernel).

// If you run this inside the kernel, your kernel's ordinary IP stack
// will stop getting packets from ethx. This might not be convenient.
// The Print messages are printed to the system log,
// which is accessible with 'dmesg' and /var/log/messages (or /var/log/syslog).
// The most recent 2-4K of messages are stored in /click/messages (still working ?).

define($DEV eth1);
Message("Block traffic on $DEV");
FromDevice($DEV) -> Print(ok) -> Discard;