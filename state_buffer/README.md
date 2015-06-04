# xmos-startkit: state_buffer

This example conects a reader and writer task through a `state_buffer` task via
input and output interfaces. The job of the state buffer is to store the last
value set for each index and notify the reader when a value has changed.

## Build & Run

See the master README at the root of this repository first, for help getting
started.

### Using the simulator

Build and run the application using `xmake` and `xsim`.

```sh
xmake && xsim bin/state_buffer.xe --max-cycles 1000000
```

If you see a series of lines in your console indicating values written to and
read from the state buffer then it worked. The `--max-cycles` option causes the
simulation to terminate after the specified number of cycles.

### Using the startKIT

Build and run the application using `xmake` and `xrun`. With the startKIT
plugged in...

```sh
xmake && xrun --io bin/state_buffer.xe
```

The `--io` flag causes xrun to print the applications `stdout` and `stderr`
streams to the console. If you see a series of lines in your console indicating
values written to and read from the state buffer then it worked.
