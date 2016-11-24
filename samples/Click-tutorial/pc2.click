define($IFACENAME eth1);
define($LOCALIP 192.168.56.89);
define($LOCALMAC d8:9d:67:99:55:8e);
AddressInfo($IFACENAME $LOCALIP $LOCALMAC);
define($LOCALPORT 1234);
define($REMOTEPORT 4321);
define($REMOTEIP 192.168.56.47);
define($LOGTICK 60);
define($PROMISC true);

Message("use IFACENAME = $IFACENAME, LOCALIP = $LOCALIP, LOCALMAC = $LOCALMAC");

// NB if eth1 ip differs from AddressInfo needs to use PROMISC param
FromDevice($IFACENAME, PROMISC $PROMISC)
  -> cl :: Classifier(12/0800,  // IP packets
      12/0806 20/0002,  // ARP Replies
      12/0806 20/0001   // ARP Queries
      )       // other automatically disarded
  -> Print("IP")
  -> CheckIPHeader(14)  // NB  sets the destination IP address annotation to the actual destination IP address.
  -> ip_cl :: IPClassifier(udp port $LOCALPORT, udp port $REMOTEPORT)
  -> Strip(42)
  -> DummyRequest
  -> udpip_encap :: UDPIPEncap($IFACENAME, 4444, $REMOTEIP, $REMOTEPORT)
  -> arpq :: ARPQuerier($IFACENAME)
  -> out :: Queue
  -> ToDevice($IFACENAME);

cl[1] -> [1]arpq;
cl[2] -> Print("ARP") -> ARPResponder($IFACENAME) -> Print("RARP") -> out;
arpq[1] -> out;

ip_cl[1]
  -> Strip(42)
  -> DummyPrint
  -> dummy_cl :: DummyClassifier
  -> DummyAnswer
  -> Print("Gen DummyAnswer with")
  -> udpip_encap;

dummy_cl[1] -> DummyLog(TICK $LOGTICK);

dummy_cl[2]
  -> Print("No registered answer")
  -> Discard;
