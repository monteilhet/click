// NB require using promisc mode
// disable routing, no needs to rewrite

cts :: ControlSocket(TCP,8801);

// gw 10.20.2.10 (<=> interface with server)
e0_in :: FromDevice(eth2, PROMISC true); // , OUTBOUND true
e0_out :: ToDevice(eth2, DEBUG true);

// cl 10.10.2.10 (<=> interface with client)
e1_in :: FromDevice(eth1, PROMISC true); // ,  OUTBOUND true
e1_out :: ToDevice(eth1, DEBUG true);

addr_gw :: AddressInfo(eth2 10.20.2.10 08:00:27:19:17:87);
addr_cl :: AddressInfo(eth1 10.10.2.10 08:00:27:e6:67:44);

arpq_gw :: ARPQuerier(eth2);
arpq_cl :: ARPQuerier(eth1);


nds_gw :: IP6NDSolicitor(fe80::a00:27ff:fe19:1787, 08:00:27:19:17:87);
nds_cl :: IP6NDSolicitor(fe80::a00:27ff:fee6:6744, 08:00:27:e6:67:44);


cls_gw :: Classifier(12/0800,  // IP packets
        12/0806 20/0002,  // ARP Replies
        12/86dd 20/3aff 54/88, // ICMP v6 Neighbor Advertisment
        12/86dd          // IPV6
      );

// NB ARP Queries and NDP Solicititation are handle by the stack
//      12/0806 20/0001   // ARP Queries


cls_cl :: Classifier(12/0800,  // IP packets
      12/0806 20/0002,  // ARP Replies
      12/86dd 20/3aff 54/88, // ICMP v6 Neighbor Advertisment
      12/86dd         // IPV6
      );

// NB ARP Queries and NDP Solicititation are handle by the stack
//    12/0806 20/0001   // ARP Queries


cls_dest :: IPClassifier(dst 10.20.2.0/24);
cls_src :: IPClassifier(dst 10.10.2.0/24);

cls6_dest :: Classifier(24/fc00000000000002);
cls6_src ::  Classifier(24/fc00000000100002);

cf :: Counter;
cb :: Counter;
cf6 :: Counter;
cb6 :: Counter;

// Filter traffic from e1_in to 10.20.2.10 and redirect to e0_in

// Forward traffic from cl to gw
e1_in -> cls_cl -> CheckIPHeader(14) -> cls_dest -> Print("gtw") -> cf -> Strip(14) 
-> arpq_gw -> qb::Queue -> Print("IP FOR") -> e0_out;

cls_gw[1] -> [1]arpq_gw;

// ArpQueries are handled by stack in user mode
// To handle queries we may use
// cls_gw[5] -> Print("ARP") -> ARPResponder(eth2) -> Print("RARP") -> qb;

// IPv6 check cls6_dest fc00:0:0:2::/64
cls_cl[3] 
// -> Print("DBG", 14) 
-> Strip(14) -> Print("IPv6", 40) -> cls6_dest -> MarkIP6Header(0) -> IP6Print("gtw ipv6") -> cf6
-> GetIP6Address(24) -> nds_gw -> MarkIP6Header(14) -> IP6Print("nds gw ipv6") -> qb


cls_gw[2] -> [1]nds_gw;

// NDP Solicititation are handle by the stack
// to handle them we may use IP6NDAdvertiser to answer


// Back traffic from gw to cl
e0_in -> cls_gw ->  CheckIPHeader(14) -> cls_src -> Print("cli") -> cb -> Strip(14) 
-> arpq_cl -> qf::Queue -> Print("IP BCK") -> e1_out;

cls_cl[1] -> [1]arpq_cl;

cls_gw[3] 
-> Strip(14) -> Print("IPv6", 40) -> cls6_src -> MarkIP6Header() ->  IP6Print("cli ipv6") -> cb6 
->  GetIP6Address(24) -> nds_cl  -> MarkIP6Header(14) -> IP6Print("nds cl ipv6") -> qf;

cls_cl[2] -> [1]nds_cl;



