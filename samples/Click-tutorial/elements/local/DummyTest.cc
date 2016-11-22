#include <click/config.h>
// #include <click/TODO.hh>
#include "DummyTest.hh"
#include "DummyProto.hh"

CLICK_DECLS

DummyTest::DummyTest() { };
DummyTest::~DummyTest() { };

Packet *DummyTest::simple_action(Packet *p) {
  // TODO: fill

  return p;
};

CLICK_ENDDECLS
EXPORT_ELEMENT(DummyTest)
