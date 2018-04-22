#include <linux/module.h>
#include <linux/slab.h>
#include <linux/list.h>

MODULE_LICENSE("GPL v2");
MODULE_AUTHOR("Keiji Uehata <keiji.ue@gmail.com>");
MODULE_DESCRIPTION("an example of list data structure");

static LIST_HEAD(mylist);

struct mylist_entry {
  struct list_head list;
  int n;
};

static void mylist_add(int n) {
  struct mylist_entry *e = kmalloc(sizeof(*e), GFP_KERNEL); // kmalloc()によって動的にメモリを確保する。GFP_KERNELはメモリ獲得時の条件を指定。通常はGFP_KERNEL
  e->n = n; // 渡された値をmylist_entryのnに格納
  list_add(&e->list, &mylist); // list_add()によって新規エントリをリストの先頭に追加
  printk(KERN_ALERT "mylist: %d is added to the head\n", n);
}

static void mylist_show(void) {
  struct mylist_entry *e;

  printk(KERN_ALERT "mylist: show contents\n");

  list_for_each_entry(e, &mylist, list) { // 全エントリにアクセス
    printk(KERN_ALERT "%d\n", e->n); // mylistの値を表示する
  }
}

static int mymodule_init(void) {
  mylist_show();
  mylist_add(1);
  mylist_show();

  return 0;
}

static void mymodule_exit(void) {
        /* Do nothing */
}

module_init(mymodule_init);
module_exit(mymodule_exit);
