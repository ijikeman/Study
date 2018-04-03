#include <linux/module.h>
#include <linux/timer.h>

MODULE_LICENSE("GPL v2");
MODULE_AUTHOR("Keiji Uehata <keiji.ue@gmail.com>");
MODULE_DESCRIPTION("timer kernel module: oneshot timer");

struct timer_list mytimer;

#define MYTIMER_TIMEOUT_SECS    10

static void mytimer_fn(unsigned long arg)
{ 
        printk(KERN_ALERT "10 secs passed.\n");
}

static int mymodule_init(void)
{
        init_timer(&mytimer); // timerの初期化
        mytimer.expires = jiffies + MYTIMER_TIMEOUT_SECS*HZ; // 1秒ごとにHZの値ずつ増えるので(jiffies[現在時刻]から10*HZ(10秒後)をExpire時間とする
        mytimer.data = 0;
        mytimer.function = mytimer_fn; // expireしたときに呼び出す関数を指定
        add_timer(&mytimer); // timerの登録

        return 0;
}

static void mymodule_exit(void)
{ 
        del_timer(&mytimer); // rmmodされた時に登録したtimerを削除する
}

module_init(mymodule_init);
module_exit(mymodule_exit);
