define($DEV eth0, $T 1, $DBG 1, $C ASCII);
Message("use config DEV = $DEV with timestamp $T debug $DBG content $C");

c :: Classifier(12/0806, 12/0800, -);  // ARP, IP, other
carp :: Classifier(12/0806 20/0001, 12/0806 20/0002, -); // ARP request , ARP response, other
d :: Discard;

FromDevice($DEV) -> c;
c[0] -> Print("[ARP Trace]", TIMESTAMP $T, CONTENTS $C) ->  ARPPrint(" -> ", TIMESTAMP $T, ACTIVE $DBG) -> carp;
carp[0] -> Print(" - [ARP REQ]", TIMESTAMP $T, CONTENTS $C) -> d;
carp[1] -> Print(" - [ARP ACK]", TIMESTAMP $T, CONTENTS $C) -> d;
carp[2] -> Print(" - [ARP ?]", TIMESTAMP $T, CONTENTS $C) -> d;

ip :: IPClassifier(tcp, udp, icmp, -);

c[1] -> Print("[IP Trace]", TIMESTAMP $T, MAXLENGTH 32, CONTENTS $C)
 -> IPPrint(" -> ", CONTENTS HEX, TIMESTAMP $T, ACTIVE $DBG, CONTENTS $C)
 -> ip;

ip[0] -> Print(" - [tcp]", MAXLENGTH 1, CONTENTS $C) -> d;
ip[1] -> Print(" - [udp]", MAXLENGTH 1, CONTENTS $C) -> d;;
ip[2] -> Print(" - [icmp]", MAXLENGTH 1, CONTENTS $C) -> d;
ip[3] -> Print(" - [other]", CONTENTS $C) -> d;

c[2] -> Print("? Trace", TIMESTAMP $T, CONTENTS $C) -> d;
