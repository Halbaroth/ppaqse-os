#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <ctype.h>
#include <stdbool.h>
#include <unistd.h>

static inline bool is_pid(char *name) {
  while (*name && isdigit(*name))
    name++;
  return *name == '\0';
}

int main(void) {
  printf("My pid: %d\n", getpid());

  DIR *dir = opendir("/proc");
  if (!dir)
    return EXIT_FAILURE;

  struct dirent *ent;
  while ((ent = readdir(dir)) != NULL) {
    if (is_pid(ent->d_name))
      printf("%s\n", ent->d_name);
  }

  closedir(dir);
  return EXIT_SUCCESS;
}
