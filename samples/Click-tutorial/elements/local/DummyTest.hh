#ifndef CLICK_DUMMYTEST__HH
#define CLICK_DUMMYTEST__HH

#include <click/element.hh>

CLICK_DECLS

/*
=c

DummyTest(TODO)

=s

TODO: Summary

=d

TODO: Complete description

*/
class DummyTest : public Element {
  //TODO: Add private attributes

  public:
    DummyTest();
    ~DummyTest();

    const char *class_name() const { return "DummyTest"; }
    const char *port_count() const { return "1/1"; }
    const char *processing() const { return AGNOSTIC; }

    Packet *simple_action(Packet *p);
};

CLICK_ENDDECLS

#endif
