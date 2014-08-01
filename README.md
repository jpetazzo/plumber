The idea is that you start a plumbing container (just once):

$ docker run -d --name plumber [a bunch of -v and other options...] jpetazzo/plumber --daemon
e2aef98cae4008e0aa7fcbc1c1886d9d69a2cefca35db964cf5e29bea38f40ed

Then, let's say you want custom networking for a www containers:

$ docker run -d --volumes-from plumber jpetazzo/plumber --macvlan --interface=eth0 [--macaddr=XXX] --ipaddr=dhcp [other custom params...]
212efe2e154e91e00fe5d91508ff878dc2f0ca7130acc86f34687a624f3d046c
$ docker run -d --name www --net container:212efe2e jpetazzo/mywebapp
ff59d905858dd8cbcebc0d71e68d467edfe320745d0fdce67979dc7ee89f9682

