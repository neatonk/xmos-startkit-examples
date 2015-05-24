#include <xs1.h>
#include <platform.h>

#include <stdio.h>

static void hello (char * place) {
  printf("Hello %s\n", place);
}

int main () {
  par {
    hello("World");
    hello("Solar System");
    hello("Milky Way");
    hello("Universe");
  }
  return 0;
}
