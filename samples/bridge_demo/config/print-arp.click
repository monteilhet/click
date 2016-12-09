define($DEV eth2, $TS true);
Message("print packets received from $DEV", MESSAGE);

i :: FromDevice($DEV);
c :: Classifier(12/0806, 12/0800, -);  // ARP, IP, other
p :: Print(FromDevice, TIMESTAMP $TS);
d :: Discard;

i -> p -> c;
c[0] -> ARPPrint(TIMESTAMP $TS) -> d;
c[1] -> IPPrint(CONTENTS HEX, TTL true) -> d;    // PAYLOAD HEX
c[2] -> d;

