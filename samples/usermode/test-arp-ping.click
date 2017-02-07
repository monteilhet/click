// test-arp-ping.click

// Click read packets from the network and respond to arp and ping request for LOCALIP.

// Run with: click [DEV=ethx] testdevice.click
// (runs as a user-level program; uses Linux packet sockets or a similar mechanism)

// test outside of the box with
// arping -I vboxnet0 192.168.56.60 -c 1
// ping 192.168.56.60 -c 1


define($DEV eth1);
Message("Handle traffic on $DEV");

define($LOCALIP 192.168.56.60);
define($LOCALMAC 5c:f9:00:00:00:0a);

AddressInfo($DEV $LOCALIP $LOCALMAC);

source :: FromDevice($DEV, SNIFFER true, PROMISC true);
sink   :: ToDevice($DEV);
// classifies packets
c :: Classifier(
    12/0806 20/0001, // ARP Requests goes to output 0
    12/0806 20/0002, // ARP Replies to output 1
    12/0800, // ICMP Requests to output 2
    ); // without a match to output 3


arpq :: ARPQuerier($LOCALIP, $LOCALMAC);
arpr :: ARPResponder($LOCALIP $LOCALMAC);

source -> c;

// ARP response for an arp request
c[0] -> Print('arpr') -> arpr  -> q ::Queue -> sink;
// handle ARP respnse, update internal ARP table
c[1] -> ARPPrint -> [1]arpq;


// first way : ping response swaps Ethernet source and destination with EtherMirror and sends packet to device
// c[2] -> CheckIPHeader(14) -> ic :: IPClassifier(ip proto icmp, -) -> Print("Ping") -> ICMPPingResponder() -> EtherMirror() -> q;
// ic[1] -> arpq;

// second way : send ping response without ethernet frame, use arpq to set ethernet frame
c[2] -> CheckIPHeader(14) -> ic :: IPClassifier(ip proto icmp) -> Print("Ping") -> ICMPPingResponder() -> Strip(14) -> arpq;

arpq -> q;
