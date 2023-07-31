## Tools for Testing Network Quality Measurement Tools

This repository contains scripts that might be valuable when
testing the tools used to test network quality tools. How meta
is that?

### Traffic Control

In Linux, there is a family of related tools under the name of 
[Traffic Control](https://tldp.org/HOWTO/Traffic-Control-HOWTO/intro.html)
that can be used to set limits (and other parameters) on network interfaces. 
Changing the limits and parameters is useful when testing different 
applications ability to cope with different network conditions. Under
the `tc` directory are scripts that help use 
[`tc`](https://man7.org/linux/man-pages/man8/tc.8.html).

See [tc/README.md](tc/README.md) for more information.
