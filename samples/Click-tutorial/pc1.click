define($IFACENAME enp2s0);
AddressInfo($IFACENAME 192.168.56.47 5c:f9:dd:4e:5f:81);
define($LOCALPORT 1234);
define($REMOTEPORT 4321);
define($REMOTEIP 192.168.56.89);

FromDevice($IFACENAME, PROMISC true)   // Print("Debug") ->
  -> cl :: Classifier(12/0800,  // IP packets
      12/0806 20/0002,  // ARP Replies
      12/0806 20/0001   // ARP Queries
      )       // other automatically disarded
  // -> Print("IP")
  -> CheckIPHeader(14)  // NB  sets the destination IP address annotation to the actual destination IP address.
  -> ip_cl :: IPClassifier(udp port $LOCALPORT, udp port $REMOTEPORT)
  -> Strip(42)
  // -> Print("DummyReq")
  -> DummyRequest
  -> udpip_encap :: UDPIPEncap($IFACENAME, 4444, $REMOTEIP, $REMOTEPORT)
  -> arpq :: ARPQuerier($IFACENAME)
  -> out :: Queue
  -> ToDevice($IFACENAME);

cl[1] -> [1]arpq;
cl[2] -> ARPResponder($IFACENAME) -> out;
arpq[1] -> out;

ip_cl[1]
  -> Strip(42)
  -> DummyPrint
  -> dummy_cl :: DummyClassifier
  -> DummyAnswer
  -> udpip_encap;

dummy_cl[1] -> DummyLog;

dummy_cl[2] -> Discard;
