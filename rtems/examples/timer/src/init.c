#include <stdio.h>
#include <stdlib.h>
#include <rtems.h>
#include <bsp/watchdog.h>

rtems_id task_id;
rtems_id watchdog_id;

rtems_timer_service_routine dead() {
}

rtems_task task(rtems_task_argument ignored) {
  status = rtems_timer_fire_after(
    watchdog_id,
    5 * rtems_clock_get_ticks_per_second(),
    dead,
    NULL
  );
  directive_failed(status, "rtems_timer_fire_after");
}

rtems_task Init(rtems_task_argument ignored) {
  rtems_name task_name = rtems_build_name('O', 'C', 'A', 'M');
  puts("Creating task");
  status = rtems_task_create(
    task_name,
    1,
    RTEMS_MINIMUM_STACK_SIZE,
    RTEMS_NO_PREEMPT,
    RTEMS_GLOBAL,
    &task_id
  );
  directive_failed(status, "rtems_task_create");

  puts("Starting task");
  status = rtems_task_start(id, , 0);
  directive_failed(status, "rtems_task_start");

  rtems_name watchdog_name = rtems_build_name('W', 'A', 'T', 'C');
  status = rtems_timer_create(watchdog_name, &watchdog_id);
  directive_failed(status, "rtems_timer_create");

  exit(0);
}

#define CONFIGURE_APPLICATION_NEEDS_CLOCK_DRIVER
#define CONFIGURE_APPLICATION_NEEDS_CONSOLE_DRIVER
#define CONFIGURE_MAXIMUM_TASKS 1
#define CONFIGURE_MAXIMUM_TIMERS 1
#define CONFIGURE_RTEMS_INIT_TASKS_TABLE
#define CONFIGURE_INIT
#include <rtems/confdefs.h>

