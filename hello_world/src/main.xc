#include <xs1.h>
#include <platform.h>

#include <stdio.h>

// An enum used to efficiently represent each place.
typedef enum place {
  WORLD,
  SOLAR_SYSTEM,
  MILKY_WAY,
  UNIVERSE,
} place;

// A function mapping each enum value to a name.
char * alias name (place p)
{
  switch (p) {
  case WORLD:
    return "World";
    break;
  case SOLAR_SYSTEM:
    return "Solar System";
    break;
  case MILKY_WAY:
    return "Milky Way";
    break;
  case UNIVERSE:
    return "Universe";
    break;
  }
  return "";
}

// A task that puts four places onto a channel.
static void a (chanend c)
{
  c <: WORLD;
  c <: SOLAR_SYSTEM;
  c <: MILKY_WAY;
  c <: UNIVERSE;
}

// A task that reads each place from the channel, printing a greeting for each
// one. Exits and say goodbye after remaining idle for too long.
static void b (chanend c)
{
  timer t;
  int t0;
  t :> t0;

  int done = 0;
  while (!done) {

    // Select statements are typically not ordered, but in this example, we want
    // to make sure that the channel is emptied before exiting the loop.
    [[ordered]]
    select {

    // Executed repeatedly until the channel is empty.
    case c :> place p:
      // Say hello and restart the timer.
      printf("Hello %s.\n", name(p));
      t :> t0;
      break;

    // Not executed until the channel is empty.
    case t when timerafter(t0 + 1) :> void:
      // Say goodbye and exit the loop.
      printf("Goodbye!\n");
      done = 1;
      break;
    }
  }
}

int main () {
  chan c;
  par {
    a(c); // core0
    b(c); // core1
  }
  return 0;
}
