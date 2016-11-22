#include <click/config.h>
#include <click/args.hh>
#include "DummyLog.hh"
#include "DummyProto.hh"

CLICK_DECLS

DummyLog::DummyLog() : _timer((Element *) this) { };
DummyLog::~DummyLog() { };

int DummyLog::initialize(ErrorHandler *) {
  _timer.initialize((Element *) this);
  _timer.schedule_now();

  return 0;
}

int DummyLog::configure(Vector<String> &conf, ErrorHandler *errh) {

  if (Args(conf, this, errh).read_or_set("TICK", _tick, 5).complete() < 0)
    return -1;

  return 0;
}

void DummyLog::run_timer(Timer *t) {
  assert(&_timer == t);
  _timer.reschedule_after_sec(_tick);

  if (_answers.empty()) {
    click_chatter("LOG is empty");
    return;
  }

  click_chatter("------ LOG ------");
  int i = 0;

  for (Vector<String>::iterator it = _answers.begin(); it && i < _answers.size(); it++, i++ )
    click_chatter("[%d] %s", i, it->c_str());

  click_chatter("---- END LOG ----");
}

Packet *DummyLog::simple_action(Packet *p) {
  struct DummyProto *proto = (struct DummyProto*) p->data();
  String s;

  s += "{ Len: ";
  s += String(proto->Len);
  s += ", Data: '";
  s += String(proto->Data, strnlen(proto->Data, DUMMYPROTO_DATA_LEN)).printable();
  s += "' }";

  _answers.push_back(s);
  p->kill();

  return NULL;
}

CLICK_ENDDECLS
EXPORT_ELEMENT(DummyLog)