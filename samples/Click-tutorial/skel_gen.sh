#!/bin/bash

function print_help() {
  echo -e "\nUsage: $0 <class_name> <port_count> <processing>\n"
  echo -e "\tclass_name\tMust be in the form : DummyElem (no spaces or special char)"
  echo -e "\tport_count\tThe number of ports in the form <in>/<out> : 1/2"
  echo -e "\tprocessing\tThe processing flow of the packets, one of : PUSH, PULL or AGNOSTIC"
}

if [ $# -ne 3 ]; then
  print_help
  exit 1
fi

elem_name=$1
elem_name_upper=${elem_name^^}
port_count=$2
processing=""

case $3 in 
  "PUSH" | "PULL" | "AGNOSTIC")
    processing=$3
    ;;
  *)
    echo -n "\nERROR: '\$3\' isn't available, exiting\n"
    print_help
    exit 1
    ;;
esac

echo "INFO: creating ${elem_name}.hh"

cat << __EOF__ > ${elem_name}.hh
#ifndef CLICK_${elem_name_upper}__HH
#define CLICK_${elem_name_upper}__HH

#include <click/element.hh>

CLICK_DECLS

/*
=c

${elem_name}(TODO)

=s

TODO: Summary

=d

TODO: Complete description

*/
class ${elem_name} : public Element {
  //TODO: Add private attributes

  public:
    ${elem_name}();
    ~${elem_name}();

    const char *class_name() const { return "${elem_name}"; }
    const char *port_count() const { return "${port_count}"; }
    const char *processing() const { return ${processing}; }

    Packet *simple_action(Packet *p);
};

CLICK_ENDDECLS

#endif
__EOF__

echo "INFO: creating ${elem_name}.cc"

cat << __EOF__ > ${elem_name}.cc
#include <click/config.h>
// #include <click/TODO.hh>
#include "${elem_name}.hh"
#include "DummyProto.hh"

CLICK_DECLS

${elem_name}::${elem_name}() { };
${elem_name}::~${elem_name}() { };

Packet *${elem_name}::simple_action(Packet *p) {
  // TODO: fill

  return p;
};

CLICK_ENDDECLS
EXPORT_ELEMENT(${elem_name})
__EOF__

echo "INFO: finished!"