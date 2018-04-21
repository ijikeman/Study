#include <linux/timer.h>
#include <linux/module.h>
#include <linux/debugfs.h>

#define MAX_TIMER 2

struct mytimer_data {
  char *name;
  int interval;
  struct timer_list timer;
};

struct mytimer_data data[MAX_TIMER] = {
  {
    .name = "foo",
    .interval = 10,
  },
  {
    .name = "bar",
    .interval = 20,
  }
};

static void mytimer_fn(unsigned long arg) {
  struct mytimer_data *d = (struct mytimer_data *)arg;
  printk(KERN_ALERT "%s: %d secs passed.\n",
         d->name, d->interval);
  mod_timer(&d->timer, jiffies + data->interval*HZ);
}

static int mymodule_init(void) {
  int i;
  for (i = 0; i < MAX_TIMER; i++) {
    struct mytimer_data *t = &data[i];
    init_timer(&t->timer);
    t->timer.expires = jiffies + t->interval*HZ;
    t->timer.function = mytimer_fn;
    add_timer(&t->timer);
  }
  return 0;
}

static void mymodule_exit(void) {
  int i;
  for (i = 0; i < MAX_TIMER; i++) {
    del_timer(&data[i].timer);
  }
}
module_init(mymodule_init);
module_exit(mymodule_exit);
