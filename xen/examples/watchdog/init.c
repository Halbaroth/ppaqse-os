#include <stdlib.h>
#include <stdio.h>
#include <xenctrl.h>

int main(void) {
  xc_interface *h = xc_interface_open(NULL, NULL, 0);
  if (!h)
    return EXIT_FAILURE;

  // Configure le timeout à 30 secondes.
  int timeout = 30;
  int id = xc_watchdog(h, 0, timeout);
  if (id <= 0)
    goto failed;
  printf("Watchdog initialisé\n");

  // Réinitialise le watchdog toutes les 15 secondes.
  while (1) {
    sleep(15);
    if (xc_watchdog(h, id, timeout))
      goto failed;
    printf("Watchdog rechargé\n");
  }

failed:
  xc_interface_close(h);
  return EXIT_FAILURE;
}
