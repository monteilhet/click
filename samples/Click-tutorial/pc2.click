define($IFACENAME enp0s25);
AddressInfo($IFACENAME 192.168.1.89 d8:9d:67:99:55:8e);
define($LOCALPORT 1234);
define($REMOTEPORT 4321);
define($REMOTEIP 192.168.1.47);

FromDevice($IFACENAME)
  -> cl :: Classifier(12/0800,  // IP packets
      12/0806 20/0002,  // ARP Replies
      12/0806 20/0001 // ARP Queries
      )       // other
  -> CheckIPHeader(14)
  -> ip_cl :: IPClassifier(udp port $LOCALPORT, udp port $REMOTEPORT)
  -> Strip(42)
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