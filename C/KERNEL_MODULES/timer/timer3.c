#include <linux/module.h>
#include <linux/timer.h>

MODULE_LICENSE("GPL v2");
MODULE_AUTHOR("Keiji Uehata <keiji.ue@gmail.com>");
MODULE_DESCRIPTION("timer kernel module: pass arg");

struct mytimer_data {
        char *name;
        int interval;
        struct timer_list timer;
};

// ２つのタイマー情報を格納する配列を定義
struct mytimer_data data[2] = {
        {
                .name = "foo",
                .interval = 2,
        },
        {
                .name = "bar",
                .interval = 3,
        },
};

#define MYTIMER_TIMEOUT_SECS    10

static void mytimer_fn(unsigned long arg) // argはタイマー情報を格納した構造体のポインタ
{
        struct mytimer_data *data = (struct mytimer_data *)arg;

        printk(KERN_ALERT "%s: %d secs passed.\n",
               data->name, data->interval);

        mod_timer(&data->timer, jiffies + data->interval*HZ); // タイマーが終了したら再度現在の時刻に秒数を追加しタイマー時刻を修正
}

static int mymodule_init(void)
{
        int i;

        for (i = 0; i < 2; i++) { // ２つのタイマーをセット
                struct mytimer_data *d = &data[i];
                init_timer(&d->timer);
                d->timer.function = mytimer_fn;
                d->timer.expires = jiffies + d->interval*HZ;
                d->timer.data = (unsigned long)d; // mytimer_fn()を呼び出す時に渡す値
                add_timer(&d->timer);
        }

        return 0;
}

static void mymodule_exit(void)
{
        int i;

        for (i = 0; i < 2; i++) { // 2つのタイマーを削除
                del_timer(&data[i].timer);
        }
}

module_init(mymodule_init);
module_exit(mymodule_exit);
