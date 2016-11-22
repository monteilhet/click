
# ARP processing

Using click elements :
+ **ARPQuerier**  encapsulates IP packets in Ethernet headers found via ARP (http://read.cs.ucla.edu/click/elements/arpquerier)

+ **ARPResponder** generates responses to ARP queries (http://read.cs.ucla.edu/click/elements/arpresponder)

+ **AddressInfo**  specifies address information  (http://read.cs.ucla.edu/click/elements/addressinfo)



```c

AddressInfo($IFACENAME $IP $MAC);

src :: FromDevice($IFACENAME, PROMISC true)
sink :: ToDevice($IFACENAME)
-> c0 :: Classifier(12/0806 20/0001,   // ARP requests go to output 0
                    12/0806 20/0002,   // ARP replies go to output 1
                    12/0800,           // IP paquets go to output 2
                    -);                // others go to output 3



arpq :: ARPQuerier($IP, $MAC);

// generates responses to ARP queries
arpr :: ARPResponder($IP $MAC); // or if AddressInfo defined IP and MAC associated to interfeace -> arpr :: ARPResponder($IFACENAME);

c[0] -> arpr -> out :: Queue -> sink

// handle ARP reply and update local arp table
c[1] -> [1]arpq;

// handle request : Packets arriving on input 0 should be IP packets,
Idle -> [0]arpq;

arpq[0] -> out

```

Packet ethernet header size: 12 bytes
UDP heard size : 8 bytes

# Utils

CheckIPHeader([OFFSET]) : checks IP header
MarkIPHeader(([OFFSET]) : sets IP header annotation