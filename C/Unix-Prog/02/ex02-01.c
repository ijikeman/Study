#include <unistd.h>

int main(void)
{
  char c;
  // read(fd, *buff, size)
  // 0=stdin 1=stdout
  while (read(0, &c, 1) == 1)
    write(1, &c, 1);
}

// ex02-01 < /test.txt > /tmp/test.txt
