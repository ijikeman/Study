#include <stdio.h>
#include <string.h>

struct str {
  int x;
  int y;
};

int main() {
  struct str str1;
  int a;
  int b;

  a = 1;
  b = 2;
  str1.x = 1;
  str1.y = 2;

  test(&a, &b, &str1);
  printf("%d\n%d\n%d\n%d\n", a, b, str1.x, str1.y);
}

int test(int c, int *d, struct str *str1) {
  printf("%d\n%d\n%d\n%d\n", c, *d, (*str1).x, (*str1).y);
  c = 3;
  *d = 3;
  (*str1).x = 3;
  str1->y = 4;
}
