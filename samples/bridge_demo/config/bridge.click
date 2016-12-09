FromDevice(eth1, PROMISC true) -> Print("out") ->  qo::Queue ->  Print("tout") -> ToDevice(eth2)
FromDevice(eth2, PROMISC true) -> Print("in") -> qi::Queue -> Print("tin") -> ToDevice(eth1)
