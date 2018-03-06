#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h> // perror()
#include <unistd.h>

int main(void)
{
  int fd, fd2;
  if ((fd = open("/tmp/test.txt", O_RDONLY)) < 0)
    perror("open");
  if ((fd2 = open("/tmp/log.txt", O_WRONLY| O_CREAT, 0644)) < 0)
    perror("open2");
  write(fd2, "12345", 5);
  write(fd2, "67890", 5);
  close(fd2);
  return 0;
}
