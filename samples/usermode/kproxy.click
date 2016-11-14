// user level configuration : kproxy.click
// This configuration allows to proxy commands to the kernel config (using tcp connection on port 35500)

proxy :: KernelHandlerProxy
ControlSocket(TCP,35500, PROXY proxy, LOCALHOST true)