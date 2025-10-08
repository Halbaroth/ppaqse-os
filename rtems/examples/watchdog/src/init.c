#include <rtems.h>
#include <stdio.h>
#include <stdlib.h>
#include <bsp/watchdog.h>

#define CONFIGURE_APPLICATION_NEEDS_CLOCK_DRIVER
#define CONFIGURE_APPLICATION_NEEDS_CONSOLE_DRIVER
#define CONFIGURE_MAXIMUM_TASKS 1
#define CONFIGURE_RTEMS_INIT_TASKS_TABLE
#define CONFIGURE_INIT
#include <rtems/confdefs.h>

rtems_task Init(rtems_task_argument ignored) {
  raspberrypi_watchdog_init();

  // Configure le timeout à 10 secondes.
  raspberrypi_watchdog_start(10 * 1000);
  printf("\nWatchdog initialisé\n");

  // Réinitialise le watchdog toutes les 5 secondes.
  while (1) {
    raspberrypi_watchdog_reload();
    printf("Watchdog rechargé\n");
    rtems_task_wake_after (RTEMS_MICROSECONDS_TO_TICKS (5 * 1000));
  }
}
