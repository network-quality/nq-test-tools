## Linux Traffic Control Tools

### `setrate.sh`

`setrate.sh` can be used to, well, set the rate of a network interface:

```console
$ ./setrate.sh create
$ ./setrate.sh destroy
```

Configuration is done using the `rate_mbit` and `shaped_iface` variables. You
will probably not need to change `ifb_iface`.

