
define($DEV eth2, $PORT 8080)

i :: FromDevice($DEV)
c :: Classifier(12/0800, -);  // IP, other
h :: CheckIPHeader(14);  // set annotations
pro :: IPClassifier(tcp || udp, -)
pt :: IPClassifier(dst port $PORT, -)  // filter dst packet
host :: ToHost;
d :: Discard;

i -> c -> h -> pro -> pt -> IPPrint("Valid") -> host;
c[1] -> host;
pro[1] -> host;
pt[1] -> IPPrint("Reject") -> d;

