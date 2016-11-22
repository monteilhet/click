#ifndef CLICK_DUMMYREQUEST__HH
#define CLICK_DUMMYREQUEST__HH

#include <click/element.hh>
#include <clicknet/ether.h>
#include <clicknet/udp.h>

CLICK_DECLS

/*
=c
DummyRequest()
=s
Generates a Dummy Request packet using another packet as input.
=d
The input packet data must be a valid C type string. Also the data pointer of
the packet must be positioned at the beginning of the string!
*/
class DummyRequest : public Element {
  Packet *gen_dummy_request(String s);
  int headroom = sizeof(click_ip) + sizeof(click_udp) + sizeof(click_ether);

  public:
    DummyRequest();
    ~DummyRequest();

    const char *class_name() const { return "DummyRequest"; }
    const char *port_count() const { return "1/1"; }
    const char *processing() const { return AGNOSTIC; }

    Packet *simple_action(Packet *p);
};

CLICK_ENDDECLS

#endif