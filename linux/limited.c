#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(void) {
  size_t sz = 0;

  printf("How many bytes do you want to allocate? ");
  if (scanf("%zu", &sz) != 1) {
    printf("Invalid size\n");
    return EXIT_FAILURE;
  }

  char *buf = malloc(sz * sizeof(*buf));
  if (!buf) {
    printf("Cannot allocate %zu bytes\n", sz);
    return EXIT_FAILURE;
  }

  memset(buf, 0, sz);
  free(buf);
  return EXIT_SUCCESS;
}
