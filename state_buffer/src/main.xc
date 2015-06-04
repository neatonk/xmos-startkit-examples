#include <xs1.h>
#include <platform.h>
#include <stdio.h>

/**
 * Streaming input and output interfaces.
 */
typedef interface input_if {
  void write(int index, int value);
} input_if;

typedef interface output_if {
  [[notification]] slave void data();
  [[clears_notification]] {int, int} read();
} output_if;


/**
 * Task which accumulates some state based on some `input` and notifies clients
 * of `output` when new data is ready to be `read`.
 */
[[combinable]]
static void state_buffer (server input_if input,
                          server output_if output,
                          static const int n)
{
  int state[n];
  unsigned changed = 0x0;
  int offset = sizeof(changed) * 8 - 1; //31

  while (1) {
    select {
    case input.write(int i, int val):
      if (val != state[i]) {
        changed |= (1 << i); // mark as changed
        state[i] = val; // update val by index
        output.data(); // notify output
      }
      break;
    case output.read() -> {int i, int val}:
      if (changed) {
        // find first changed bit set to 1
        i = offset - __builtin_clz(changed);
        // set return value
        val = state[i];
        // unset changed bit
        changed &= ~(1 << i);
      } else {
        // indicate no change
        i = -1; val = -1;
      }
      break;
    }
  }
}

/**
 * Function used to generate a series of `input` values that change over time.
 */
static int v(int n, int maxn, int maxv)
{
  n %= (maxn + 1);
  return n == 0 ? 0 : maxv / n;
}

/**
 * Task which periodically writes data to the `input` interface.
 */
[[combinable]]
static void writer (client input_if input, int n)
{
  timer t;

  int cps = 1;
  int period = cps * XS1_TIMER_HZ;
  int delay = period / ( cps * 60 );

  int i;
  int val;
  int time;
  int tick = 0;
  t :> time;

  while (1) {
    select {
    case t when timerafter(time) :> void:
      tick %= n; // wrap around
      i = n;
      while (i) {
        i--;
        // calculate value
        val = v(tick + i, n - 1, 255);
        // write to the state input
        input.write(i, val);
        printf("w %d, %d\n", i, val);
      }
      time += delay;
      tick++;
      break;
    }
  }
}

/**
 * Task which reads data from the `output` interface when ready. Waits for a
 * notification from the `server` and read one value at a time until there is no
 * more data available.
 */
[[combinable]]
void reader (client output_if output)
{
  while (1) {
    select {
    case output.data():
      int i;
      int val;
      while (1) {
        {i, val} = output.read();
        if (i >= 0) {
          printf("r %d, %d\n", i, val);
        } else {
          break;
        }
      }
      break;
    }
  }
}

int main ()
{
  input_if input;
  output_if output;
  par {
    state_buffer(input, output, 9);
    writer(input, 9);
    reader(output);
  }
  return 0;
}
