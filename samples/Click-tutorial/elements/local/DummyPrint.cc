
#include <click/config.h>
#include <click/glue.hh>
#include "DummyPrint.hh"
#include "DummyProto.hh"

CLICK_DECLS

DummyPrint::DummyPrint() { };
DummyPrint::~DummyPrint() { };

Packet *DummyPrint::simple_action(Packet *p) {
/*
simple_action(...) method is often the one you need, especially in AGNOSTIC flow,
think of it as a filter applied to each packet passing through your element.
*/

  // expect a packet stripped to the UDP data,
  // we get the data pointer of the packet and cast it to our protocol structure.
  struct DummyProto *proto = (DummyProto *) p->data();
  uint8_t anno_val = DUMMYPROTO_ANSWER + 1;

  if (proto->T == DUMMYPROTO_REQUEST) {
    click_chatter("Request: %s", String(proto->Data, DUMMYPROTO_DATA_LEN).c_str());
    anno_val = (uint8_t) DUMMYPROTO_REQUEST;

  } else if (proto->T == DUMMYPROTO_ANSWER) {
    click_chatter("Answer: %s", String(proto->Data, DUMMYPROTO_DATA_LEN).c_str());
    anno_val = (uint8_t) DUMMYPROTO_ANSWER;

  } else
    click_chatter("ERROR: unknow type for packet");

  p->set_anno_u8(DUMMY_CLASSIFY_ANNO_OFFSET, anno_val);

  return p;
};

CLICK_ENDDECLS
EXPORT_ELEMENT(DummyPrint)