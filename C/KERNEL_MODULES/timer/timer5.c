#include <linux/module.h>
#include <linux/timer.h>
#include <linux/debugfs.h>

MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("A simple example of debugfs");

static struct dentry *testfile;
static char testbuf[128];

struct timer_list mytimer;

#define MYTIMER_TIMEOUT_SECS    ((unsigned long)1000)

static void mytimer_fn(unsigned long arg)
{
        printk(KERN_ALERT "%lu secs passed.\n", MYTIMER_TIMEOUT_SECS);
}

static ssize_t mytimer_remain_msecs_read(struct file *f, char __user *buf, size_t len, loff_t *ppos)
{
        printk(KERN_ALERT "call mytimer_remain_msecs_read()");

        unsigned long diff_msecs, now = jiffies;

        if (time_after(mytimer.expires, now)) // 時刻aが時刻bより先であれば1を、そうでなければ0を返す。 unsigned long型での比較なのでtime_after()を使っている
                diff_msecs = (mytimer.expires - now) * 1000 / HZ;
        else
                diff_msecs = 0;

        snprintf(testbuf, sizeof(testbuf), "%lu\n", diff_msecs);
        return simple_read_from_buffer(buf, len, ppos, testbuf, strlen(testbuf)); //simple_read_from_buffer()はtestbufの内容をユーザ空間のバッファであるbufに渡している
}

static struct file_operations test_fops = {
        .owner = THIS_MODULE,
        .read = mytimer_remain_msecs_read, // debugfsのファイルを読んだ時に呼び出される関数
};

static int mymodule_init(void)
{
        init_timer(&mytimer);
        mytimer.expires = jiffies + MYTIMER_TIMEOUT_SECS*HZ;
        mytimer.data = 0;
        mytimer.function = mytimer_fn;
        add_timer(&mytimer);

        testfile = debugfs_create_file("mytimer_remain_msecs", 0400, NULL, NULL, &test_fops); // /sys/kernel/debug/mytimer_remain_msecsというファイルを生成する
        if (!testfile)
                return -ENOMEM;

        return 0;
}

static void mymodule_exit(void)
{
        debugfs_remove(testfile); // /sys/kernel/debug/mytimer_remain_msecsを削除
        del_timer(&mytimer);
}

module_init(mymodule_init);
module_exit(mymodule_exit);
