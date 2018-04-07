#include <linux/module.h>
#include <linux/timer.h>

MODULE_LICENSE("GPL v2");
MODULE_AUTHOR("ijikeman");
MODULE_DESCRIPTION("timer kernel module: oneshot timer");

#define MYTIMER_TIMEOUT_SECS 10
#define MYTIMER_INTERVAL 5

struct timer_list mytimer;
int timer_count = 0;

static void mytimer_fn(unsigned long arg) {
  timer_count++;
  printk(KERN_ALERT "count %d\n", timer_count);
  mod_timer(&mytimer, jiffies+(MYTIMER_TIMEOUT_SECS+(MYTIMER_INTERVAL*timer_count))*HZ);
}

static int mymodule_init(void) {
  init_timer(&mytimer);
  mytimer.expires = jiffies + MYTIMER_TIMEOUT_SECS*HZ;
  mytimer.function = mytimer_fn;
  mytimer.data = 0;
  add_timer(&mytimer);
  return 0;
}

static void mymodule_exit(void)
{
  del_timer(&mytimer);
  printk(KERN_ALERT "remove timer4.ko.\n");
}

module_init(mymodule_init);
module_exit(mymodule_exit);
