
# Packet classification


Packet ethernet header size: 12 bytes (ethernet frame dst:6 src:6 type:2)
IPV4 header : 20 bytes
IPV6 header : 40 bytes
UDP head size : 8 bytes

Using Classifier element
http://read.cs.ucla.edu/click/elements/classifier
Using PARAMETER :  offset/value

At offset 12 (in ethernet frame) can filter by type
+ 0x86DD : ipv6
+ 0x0800 : ipv4
+ 0x0806 : ARP

Strip(14) : Remove ethernet header


# Utils

CheckIPHeader([OFFSET]) : checks IP header and set annotation
MarkIPHeader(([OFFSET]) : sets IP header annotation



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
