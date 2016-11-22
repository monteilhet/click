#ifndef CLICK_DUMMYLOG__HH
#define CLICK_DUMMYLOG__HH

#include <click/element.hh>
#include <click/timer.hh>

CLICK_DECLS

/*
=c
DummyLog(TICK)
=s
Log the received answers and prints them periodically.
=d
Print the received answers every TICK seconds.
*/
class DummyLog : public Element {
  Vector<String> _answers;   //  is used to collect answers strings
  Timer _timer;
  unsigned int _tick;        // is used to define the time interval between timer ticks

  void run_timer(Timer *t);  // Triggered on a tick

  public:
    DummyLog();
    ~DummyLog();

    const char *class_name() const { return "DummyLog"; }
    const char *port_count() const { return "1/0"; }
    const char *processing() const { return AGNOSTIC; }

    Packet *simple_action(Packet *p);
    int initialize(ErrorHandler *);
    int configure(Vector<String> &conf, ErrorHandler *errh);
};

CLICK_ENDDECLS

#endif