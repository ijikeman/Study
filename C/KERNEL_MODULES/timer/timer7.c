#include <linux/module.h>
#include <linux/timer.h>
#include <linux/debugfs.h>

MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("A simple example of debugfs");

static struct dentry *topdir; // debugfs以下に専用ディレクトリを作成
static struct dentry *testfile;
static char testbuf[128];

struct timer_list mytimer;

static unsigned long mytimer_timeout_msecs = 1000 * 1000; // mili secs単位に変更し、値を1000sに変更

static void mytimer_fn(unsigned long arg)
{
        printk(KERN_ALERT "%lu secs passed.\n", mytimer_timeout_msecs / 1000);
}

static ssize_t mytimer_remain_msecs_read(struct file *f, char __user *buf, size_t len, loff_t *ppos)
{
        unsigned long diff_msecs, now = jiffies;
        printk(KERN_ALERT "call mytimer_remain_msecs_read()");

        if (time_after(mytimer.expires, now))
                diff_msecs = (mytimer.expires - now) * 1000 / HZ;
        else
                diff_msecs = 0;

        snprintf(testbuf, sizeof(testbuf), "%lu\n", diff_msecs);
        return simple_read_from_buffer(buf, len, ppos, testbuf, strlen(testbuf));
}

static ssize_t mytimer_remain_msecs_write(struct file *f, const char __user *buf, size_t len, loff_t *ppos) {
  ssize_t ret;

  printk(KERN_ALERT "call mytimer_remain_msecs_write()");

  ret = simple_write_to_buffer(testbuf, sizeof(testbuf), ppos, buf, len); // ユーザ空間のバッファであるbufから、カーネル空間のバッファtestbufにデータを書き込む
  if (ret < 0)
    return ret;

  sscanf(testbuf, "%20lu", &mytimer_timeout_msecs); // testbufから読み取った値をmytimer_timerout_msecsに格納
  mod_timer(&mytimer, jiffies + mytimer_timeout_msecs*HZ/1000); // タイマーの時間を変更する
  return ret;
}

static struct file_operations test_fops = {
        .owner = THIS_MODULE,
        .read = mytimer_remain_msecs_read,
        .write = mytimer_remain_msecs_write, // debugfsのファイルに書きだした時に呼び出す関数
};

static int mymodule_init(void)
{
        init_timer(&mytimer);
        mytimer.expires = jiffies + mytimer_timeout_msecs*HZ;
        mytimer.data = 0;
        mytimer.function = mytimer_fn;
        add_timer(&mytimer);

        topdir = debugfs_create_dir("mytimer", NULL);
        if (!topdir)
                return -ENOMEM;
        testfile = debugfs_create_file("remain_msecs", 0400, NULL, NULL, &test_fops);
        if (!testfile)
                return -ENOMEM;

        return 0;
}

static void mymodule_exit(void)
{
        debugfs_remove_recursive(topdir);
        del_timer(&mytimer);
}

module_init(mymodule_init);
module_exit(mymodule_exit);
