#ifndef CLICK_DUMMYANSWER__HH
#define CLICK_DUMMYANSWER__HH

#include <click/element.hh>
#include <click/hashtable.hh>
#include <clicknet/ether.h>
#include <clicknet/udp.h>

CLICK_DECLS

/*
=c
DummyAnswer()
=s
Generates a packet with a preformated answer to a DummyRequest packet.
*/
class DummyAnswer : public Element {
  HashTable<String, String> _msgs;

  // r/w handler to setup hashtable with request_string|answer_string
  static int write_callback(const String &s, Element *e, void *vparam, ErrorHandler *errh);
  static String read_callback(Element *e, void *vparam);
  int headroom = sizeof(click_ip) + sizeof(click_udp) + sizeof(click_ether);

  public:
    DummyAnswer();
    ~DummyAnswer();

    const char *class_name() const { return "DummyAnswer"; }
    const char *port_count() const { return "1/1"; }
    const char *processing() const { return AGNOSTIC; }

    Packet *simple_action(Packet *p);
    void add_handlers();
};

CLICK_ENDDECLS

#endif