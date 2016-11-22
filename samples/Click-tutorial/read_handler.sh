#!/bin/bash

###
# Uses openbsd variant of netcat
###

# Host of the control socket
host="${HOST:?}"
# Port number of the control socket
port=${PORT:?}
# The short element's name (e.g. _not_ flatten by click)
short_name="${SHORT_NAME:?}"
# The handler name of the element
handler_name="${HANDLER_NAME:?}"

printf "connect to $host:$port using $short_name element\n"

##
## Do not modify below
##

# extract full name from the element list
full_name=$(echo "READ list" | nc -q 1 ${host} ${port} | grep ${short_name})

printf "fullname element is ${full_name}\n"


if [ "x${full_name}" == "x" ]; then
  echo "[-] No element named ${short_name} found!"
  exit 1
fi

# list all handlers and see if we have it
handlers_list=$(echo "READ ${full_name}.handlers" | nc -q 1 ${host} ${port})

echo "$handlers_list" | grep -q ${handler_name}

if [ $? -ne 0 ]; then
  echo "[-] No handler named ${handler_name} for ${full_name}"
  exit 1
fi

# The real deal, send the read order to the handler
echo -e "READ ${full_name}.${handler_name}\n" | nc -q 1 ${host} ${port}