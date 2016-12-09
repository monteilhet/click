// use this user level click configuration to proxy handlers request to the kernel config
// click kproxy.click
// telnet click-vm-ip 8800

proxy :: KernelHandlerProxy
ControlSocket(TCP,8800, PROXY proxy, LOCALHOST false)
