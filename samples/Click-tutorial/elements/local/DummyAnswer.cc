#include <click/config.h>
#include <click/args.hh>
#include "DummyAnswer.hh"
#include "DummyProto.hh"

CLICK_DECLS

DummyAnswer::DummyAnswer() { };
DummyAnswer::~DummyAnswer() { };

Packet *DummyAnswer::simple_action(Packet *p) {
  struct DummyProto *proto = (struct DummyProto*) p->data();
  String s = String(proto->Data, strnlen(proto->Data, DUMMYPROTO_DATA_LEN));
  String res = _msgs.get(s);

  if (!res) {
    click_chatter("DEBUG: No response for %s", s.printable().c_str());
    p->kill();
    return NULL;
  }

  int res_len = res.length();
  res.append_fill('\0', DUMMYPROTO_DATA_LEN-res_len);

  struct DummyProto resp;
  resp.T = DUMMYPROTO_ANSWER;
  resp.Len = DUMMYPROTO_LEN_B;
  memcpy(resp.Data, res.c_str(), DUMMYPROTO_DATA_LEN);

  WritablePacket *q = Packet::make(headroom, &resp, sizeof(DummyProto), 0);
  p->kill();

  return q;
}

enum { H_MAP };

/*
 * Inject a (request, answer).
 * The input string must be formated like this:
 *  request_string|answer_string
 */
int DummyAnswer::write_callback(const String &s, Element *e, void *vparam, ErrorHandler *errh) {
  DummyAnswer *da = static_cast<DummyAnswer *>(e); 

  if ((intptr_t) vparam != H_MAP)
    return 0;

  if (s.length() > DUMMYPROTO_DATA_LEN*2 +1)
    return 1;

  int pos_delim = s.find_left('|', 0);

  if (pos_delim == -1 || pos_delim == 0 || pos_delim == s.length())
    return 1;

  int pos_req = pos_delim > DUMMYPROTO_DATA_LEN ? DUMMYPROTO_DATA_LEN : pos_delim;

  String req = s.substring(0, pos_req);
  String ans = s.substring(pos_delim+1, s.length());

  click_chatter("Adding: '%s' -> '%s'", req.printable().c_str(), ans.printable().c_str());
  da->_msgs[req] = ans;

  return 0;
}

String DummyAnswer::read_callback(Element *e, void *vparam) {
  DummyAnswer *da = static_cast<DummyAnswer *>(e); 

  if ((intptr_t) vparam != H_MAP)
    return "";
  
  String res("");
  res += "------ MSGS ------\n";

  for (HashTable<String, String>::iterator it = da->_msgs.begin(); it; it++) {
    res += it.key().printable();
    res += " -> ";
    res += it.value().printable();
    res += "\n";
  }

  res += "---- END MSGS ----\n";

  return res;
}

void DummyAnswer::add_handlers() {
  add_read_handler("h_map", read_callback, H_MAP, Handler::CALM);
  add_write_handler("h_map", write_callback, H_MAP);
}

CLICK_ENDDECLS
EXPORT_ELEMENT(DummyAnswer)