#ifndef CLICK_DUMMYPRINT__HH
#define CLICK_DUMMYPRINT__HH

#include <click/element.hh>

CLICK_DECLS

/*
=c
DummyPrint()
=s
Print the 'Data' field of the packet preposed with 'Answer: ' or 'Request: '
depending on the 'T' field.
=d
Sets an annotation of type uint8_t at DUMMY_CLASSIFY_ANNO_OFFSET to ease the
task of DummyClassifier.
*/
class DummyPrint : public Element {

  public:
    DummyPrint();
    ~DummyPrint();

    const char *class_name() const { return "DummyPrint"; }
    const char *port_count() const { return "1/1"; }
    const char *processing() const { return AGNOSTIC; }

    Packet *simple_action(Packet *p);
};

CLICK_ENDDECLS

#endif