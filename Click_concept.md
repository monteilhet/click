#  click concepts

click router : Extensible toolkit for writing packet processors

Architecture centered on elements
 * Small building blocks
 * Perform simple operations e.g. decrease TTL

Click routers : Directed graphs of elements

+ Router: Elements connected by edges
+ Output ports to input ports
+ Describes possible packet flows

Ports:
 * Push port: Source initiates packet transfer: event based packet flow
 * Pull port: Destination initiates packet transfer (Used with polling, scheduling,...)
 * Agnostic port: Becomes push or pull

Compound elements:
 * Group elements in larger elements


Elements (actually element classes): C++ classes<br>
Element instantations: C++ objects<br>
Click router configurations (or short Click routers): text files parsed when starting Click, Click builds object graph of elements

Packets:<br>
Packet consists of payload and annotations (metadata to simplify processing as "post-its" )
+ payload: raw bytes (char*)
+ annotations : packet offset designating IP header, or user defined

Handlers:
 * Like function calls to an element
 * ReadHandler: request a value from an element
 * WriteHandler: pass a string to an element
   NB (There is no ReadWriteHandler: you can’t call a ReadHandler with arguments)
 * Can be called from other elements or through socket
