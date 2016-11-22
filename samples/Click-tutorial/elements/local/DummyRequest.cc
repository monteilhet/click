#include <click/config.h>
#include "DummyRequest.hh"
#include "DummyProto.hh"

CLICK_DECLS

DummyRequest::DummyRequest() { };
DummyRequest::~DummyRequest() { };

/*
 * Generates a DummyRequest packet from a input string.
 */
Packet *DummyRequest::gen_dummy_request(String s) {
  struct DummyProto dummy_packet;
  dummy_packet.T = DUMMYPROTO_REQUEST;
  memcpy(dummy_packet.Data, s.c_str(), DUMMYPROTO_DATA_LEN);
  dummy_packet.Len = DUMMYPROTO_LEN_A;

  return Packet::make(headroom, &dummy_packet, sizeof(DummyProto), 0);
};

Packet *DummyRequest::simple_action(Packet *p) {
  Packet *q = NULL;
  int len = strnlen((const char *) p->data(), p->length());

  if (len > DUMMYPROTO_DATA_LEN)
    len = DUMMYPROTO_DATA_LEN;
  
  String s = String(p->data(), len);
  int delta = DUMMYPROTO_DATA_LEN - len;

  if (delta > 0)
    s.append_fill('\0', delta);

  click_chatter("DEBUG: p->data() = %s\tp->length() = %d", s.c_str(), p->length());

  if (p->length() > 0 && p->length() <= DUMMYPROTO_DATA_LEN + 1)
    q = gen_dummy_request(s);
  else
    click_chatter("ERROR: Input packet is too big or 0-sized!");

  p->kill();

  return q;
};

CLICK_ENDDECLS
EXPORT_ELEMENT(DummyRequest)