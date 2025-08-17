#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/watchdog.h>

int main(void) {
  int fd = open("/dev/watchdog", O_WRONLY);
  if (fd == -1)
    exit(EXIT_FAILURE);

  // Configure le timeout à 20 secondes.
  int timeout = 20;
  if (ioctl(fd, WDIOC_SETTIMEOUT, &timeout) == -1)
    goto failed;

  // Réinitialise le watchdog toutes les 10 secondes.
  while (1) {
    if (write(fd, "\0", 1) != 1)
      goto failed;
    sleep(10);
  }

  close(fd);
  return EXIT_SUCCESS;

failed:
  close(fd);
  return EXIT_FAILURE;
}
