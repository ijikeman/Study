#include <stdio.h>

int x[10],
    y[10],
    num_inputs,
    num_y = 0;

void get_args(int ac, char **av)
{
  int i;
  // プログラム名のargvは対象から外す
  num_inputs = ac - 1;
  // プログラム名以外の引数をxに格納
  for (i = 0; i < num_inputs; i++)
    x[i] = atoi(av[i+1]);
}

void scoot_over(int jj)
{
  int k;
  // 比較されて大きな値は１つ右へずらして格納する (num_y-1が間違っていたので修正) (k++ -> k--に修正)
  for (k = num_y; k > jj; k--)
    y[k] = y[k-1];
}

void insert(int new_y)
{
  int j;
  //入力された値が1つ目の場合y[0]に格納
  // = を ==に修正(bug)
  if (num_y == 0) {
    y[0] = new_y;
    return;
  }

  //渡す値が複数の場合
  for (j = 0; j < num_y; j++) {
    //新しく渡ってきた値が格納されているものよりも小さければscoot_overへ
    if (new_y < y[j]) {
      scoot_over(j);
      // 新しい値を前に格納
      y[j] = new_y;
      return;
    }
    // もうひとつの場合： new_y > 既存のyの全要素
    y[num_y] = new_y;
  }
}

void process_data()
{
  // 入力された値をinsert()に1つずつ渡す
  for (num_y = 0; num_y < num_inputs; num_y++)
    insert(x[num_y]);
}

void print_results()
{
  int i;
  for (i = 0; i < num_inputs; i++)
    printf("%d\n",y[i]);
}

int main(int argc, char ** argv)
{
  get_args(argc,argv);
  process_data();
  print_results();
  return 0;
}
