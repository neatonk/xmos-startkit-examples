# xmos-startkit: hello_world

A simple variation on the classic example, showing the use of `par` in XC.

## Build & Run

See the master README at the root of this repository first, for help getting
started.

### Using the simulator

Build and run the application using `xmake` and `xsim`.

```sh
xmake && xsim bin/hello_world.xe
```

If you see a nice set of "Hello ..." messages in your console, then it worked!

### Using the startKIT

Build and run the application using `xmake` and `xrun`. WIth the startKIT plugged in...

```sh
xmake && xrun --io bin/hello_world.xe
```

The `--io` flag causes xrun to print the applications `stdout` and `stderr` streams
to the console. If you see a nice set of "Hello ..." messages in your console, then it worked!
