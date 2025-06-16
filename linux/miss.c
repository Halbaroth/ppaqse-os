#include <stdlib.h>
#include <time.h>
#include <string.h>
#define SIZE 1000000
#define N 100000000

int main(int argc, char **argv) {
  srand(time(NULL));

  int random = argc > 1 && strcmp(argv[1], "random") == 0;
  volatile int arr[SIZE] = {0};
  for (int i = 0; i < N; i++)
    (void)arr[(i + (random ? rand() : 0)) % SIZE];

  return EXIT_SUCCESS;
}
