#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h> // perror()

int main(void)
{
  int fd;
  if ((fd = open("/tmp/test.txt", O_RDONLY)) < 0)
    perror("test");
  return 0;
}
