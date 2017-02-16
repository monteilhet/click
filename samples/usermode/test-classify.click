define($DEV eth1);
Message("classify on $DEV");

cts :: ControlSocket(TCP,35500); // opens control sockets for other programs
chs :: ChatterSocket(TCP,35501); // reports chatter messages to connected sockets

// Click elements :
// Strip : strips bytes from front of packets
// StripToNetworkHeader : strips everything preceding network header
// Unstrip : unstrips bytes from front of packets
// Print : prints packet contents ([LABEL, MAXLENGTH)
// Classifier : classifies packets by contents
// ARPPrint : pretty-prints ARP packets a la tcpdump (requires annotation to be set for ARP header)
// CheckARPHeader : checks ARP header (& set ARP header annotation)
// CheckIPHeader : checks IP header (& set IP header annotation)
// MarkIPHeader : sets IP header annotation
// IPClassifier : classifies IP packets by contents (requires annotation to be set for IP header)
// IPPrint : pretty-prints IP packets (requires annotation to be set for IP header)
// CheckIP6Header : checks IP6 header
// MarkIP6Header : Marks packets as IP6 packets by setting the IP6 Header annotation
// IP6Print : pretty-prints IP6 packets (requires annotation to be set for IP6 header)

// Classifier ARP, IP, ICMP with offset using entire packet including ethernet header
// cl :: Classifier(
// 12/0806 20/0001, // ARP request
// 12/0806 20/0002, // ARP replies
// 12/0800,         // IP packets
// 12/86DD,       // IPv6 packets
// );

// Classifer offset 0 (ethenet header has been striped)
cl :: Classifier(
0/0806 8/0001, // ARP request
0/0806 8/0002, // ARP replies
0/0800,         // IP packets
0/86DD,       // IPv6 packets
);


// classifier using packet with ethernet header stripped Offset 9 (10th byte) for protocol
// clip :: Classifier(
// 9/01,  // ICMP
// 9/06,  // tcp
// 9/11, // UDP 0x11 <=> 17
// );

// NB To use this ip classifier input packets must have their IP header annotation set
clip :: IPClassifier(
ip proto icmp,
ip proto tcp,
ip proto udp,
);

// NB there is no ipv6 classifier => use basic classifier (not using annotations)
// classifier using packet with ethernet header stripped Offset 6 ( 7h byte) for Next Header
clip6 :: Classifier(
6/3a, // ICMP
6/06,  // tcp
6/11, // UDP 0x11 <=> 17
);


FromDevice($DEV) -> Print("eth", 34) -> Print("Eth header", 12) -> Strip(12) -> Print("Eth code" , 2) -> cl;

// ARPPrint require annotation set using CheckARPHeader
cl[0] -> Strip(2) -> Print("ARP header" , 26) -> CheckARPHeader() -> ARPPrint("ARP request") -> Discard;
cl[1] -> Strip(2) -> Print("ARP header" , 26) -> CheckARPHeader() -> ARPPrint("ARP response") -> Discard;
// IPPrint require annotation set using CheckIPHeader/MarkIPHeader
cl[2] -> Strip(2) -> Print("IP header" , 20) -> MarkIPHeader() /* <=> */ /* -> CheckIPHeader*/ -> IPRateMonitor(PACKETS, 0.5, 256, 600)
-> StripIPHeader() -> IPPrint("IPV4" /*,PAYLOAD HEX*/) -> clip;

clip[0] -> Print("ICMP Type and Code" , 2 ) -> Discard;
clip[1] -> Print("TCP", 20 ) -> Strip(20) -> Print("PAYLOAD DATA") ->  Discard;
clip[2] -> Print("UDP", 8 ) -> Strip(8) -> Print("PAYLOAD DATA") ->  Discard;

// IP6Print require annotation set using CheckIP6Header/MarkIP6Header
cl[3] -> Strip(2) -> CheckIP6Header() /* <=> */ /*-> MarkIP6Header() */ -> IP6Print("IPV6") -> clip6;

clip6[0] -> Strip(40) -> Print("ICMP Type and Code" , 2 ) -> Discard;
clip6[1] -> Strip(40)-> Print("TCP",20 ) -> Strip(20) -> Print("PAYLOAD DATA") ->  Discard;
clip6[2] -> Strip(40)-> Print("UDP",8 ) -> Strip(8) -> Print("PAYLOAD DATA") ->  Discard;




// Test using outside of the vm (i.e in host)
// sudo arping -I vboxnet0 192.168.56.20 -c 1
// ping 192.168.56.20 -c 1
// ping6 fe80::a00:27ff:fe3e:3093
// echo -n '3434' | nc -4u -q1 192.168.56.20 1234 // send udp datagram

// IPV6 define a 

// sudo ip -6 addr add fd01:cafe:0:2::1/64 dev eth1
// sudo ip -6 addr add fd01:cafe:0:2::2/64 dev vboxnet0


