#ifndef CLICK_DUMMYCLASSIFIER__HH
#define CLICK_DUMMYCLASSIFIER__HH

#include <click/element.hh>

CLICK_DECLS

/*
=c
DummyClassifier()
=s
Classify according to the type of a dummy packet, this type is set in
annotations.
=d
Request packets go to the first output port and Answer to the second, the rest
goes to the 3rd output port. The annotation is an unsigned int on 8 bits and
is positionned at DUMMY_CLASSIFY_ANNO_OFFSET of the annotations.
*/
class DummyClassifier : public Element {

  public:
    DummyClassifier();
    ~DummyClassifier();

    const char *class_name() const { return "DummyClassifier"; }
    const char *port_count() const { return "1/3"; }
    const char *processing() const { return PUSH; }

    void push(int, Packet *p);
};

CLICK_ENDDECLS

#endif