// a sample configuration to show parameters usage

define($DEVNAME eth0, $COUNT 1);
Message("use config DEVNAME = $DEVNAME, COUNT = $COUNT, PROTO = $PROTO")
define($PROTO tcp);  // the definition of variables is global to the configuration and can appear anywhere,
//here for instance we define the variable after its use in the Message statement.
Script(stop);