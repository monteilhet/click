#include <click/config.h>
#include "DummyClassifier.hh"
#include "DummyProto.hh"

CLICK_DECLS

DummyClassifier::DummyClassifier() { };
DummyClassifier::~DummyClassifier() { };

void DummyClassifier::push(int, Packet *p) {
  int out_port = 2; // Default output for junk

  if (p->anno_u8(DUMMY_CLASSIFY_ANNO_OFFSET) == DUMMYPROTO_REQUEST)
    out_port = 0;

  else if (p->anno_u8(DUMMY_CLASSIFY_ANNO_OFFSET) == DUMMYPROTO_ANSWER)
    out_port = 1;

  output(out_port).push(p);
};

CLICK_ENDDECLS
EXPORT_ELEMENT(DummyClassifier)